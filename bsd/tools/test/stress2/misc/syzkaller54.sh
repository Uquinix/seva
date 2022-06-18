#!/bin/sh

# panic: td 0xfffffe014f7193a0 is not suspended
# cpuid = 5
# time = 1652003036
# KDB: stack backtrace:
# db_trace_self_wrapper() at db_trace_self_wrapper+0x2b/frame 0xfffffe019a497c20
# vpanic() at vpanic+0x17f/frame 0xfffffe019a497c70
# panic() at panic+0x43/frame 0xfffffe019a497cd0
# thread_single() at thread_single+0x766/frame 0xfffffe019a497d40
# fork1() at fork1+0x1e1/frame 0xfffffe019a497da0
# sys_rfork() at sys_rfork+0xa4/frame 0xfffffe019a497e00
# amd64_syscall() at amd64_syscall+0x145/frame 0xfffffe019a497f30
# fast_syscall_common() at fast_syscall_common+0xf8/frame 0xfffffe019a497f30
# --- syscall (0, FreeBSD ELF64, nosys), rip = 0x82317b7da, rsp = 0x826544f48, rbp = 0x826544f70 ---
# KDB: enter: panic
# [ thread pid 17068 tid 104913 ]
# Stopped at      kdb_enter+0x32: movq    $0,0x12795f3(%rip)
# db> x/s version
# FreeBSD 14.0-CURRENT #0 main-n255381-cbbce42345c51: Sun May  8 09:55:50 CEST 2022
# pho@mercat1.netperf.freebsd.org:/usr/src/sys/amd64/compile/PHO
# db> 

[ `uname -p` != "amd64" ] && exit 0

. ../default.cfg
cat > /tmp/syzkaller54.c <<EOF
// https://syzkaller.appspot.com/bug?id=346de481f8b814d103c440296a0adcb7ec6c46d4
// autogenerated by syzkaller (https://github.com/google/syzkaller)
// Reported-by: syzbot+9db4640d67478a0ced08@syzkaller.appspotmail.com

#define _GNU_SOURCE

#include <sys/types.h>

#include <errno.h>
#include <pthread.h>
#include <pwd.h>
#include <signal.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/endian.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static unsigned long long procid;

static void kill_and_wait(int pid, int* status)
{
  kill(pid, SIGKILL);
  while (waitpid(-1, status, 0) != pid) {
  }
}

static void sleep_ms(uint64_t ms)
{
  usleep(ms * 1000);
}

static uint64_t current_time_ms(void)
{
  struct timespec ts;
  if (clock_gettime(CLOCK_MONOTONIC, &ts))
    exit(1);
  return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
}

static void thread_start(void* (*fn)(void*), void* arg)
{
  pthread_t th;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setstacksize(&attr, 128 << 10);
  int i = 0;
  for (; i < 100; i++) {
    if (pthread_create(&th, &attr, fn, arg) == 0) {
      pthread_attr_destroy(&attr);
      return;
    }
    if (errno == EAGAIN) {
      usleep(50);
      continue;
    }
    break;
  }
  exit(1);
}

typedef struct {
  pthread_mutex_t mu;
  pthread_cond_t cv;
  int state;
} event_t;

static void event_init(event_t* ev)
{
  if (pthread_mutex_init(&ev->mu, 0))
    exit(1);
  if (pthread_cond_init(&ev->cv, 0))
    exit(1);
  ev->state = 0;
}

static void event_reset(event_t* ev)
{
  ev->state = 0;
}

static void event_set(event_t* ev)
{
  pthread_mutex_lock(&ev->mu);
  if (ev->state)
    exit(1);
  ev->state = 1;
  pthread_mutex_unlock(&ev->mu);
  pthread_cond_broadcast(&ev->cv);
}

static void event_wait(event_t* ev)
{
  pthread_mutex_lock(&ev->mu);
  while (!ev->state)
    pthread_cond_wait(&ev->cv, &ev->mu);
  pthread_mutex_unlock(&ev->mu);
}

static int event_isset(event_t* ev)
{
  pthread_mutex_lock(&ev->mu);
  int res = ev->state;
  pthread_mutex_unlock(&ev->mu);
  return res;
}

static int event_timedwait(event_t* ev, uint64_t timeout)
{
  uint64_t start = current_time_ms();
  uint64_t now = start;
  pthread_mutex_lock(&ev->mu);
  for (;;) {
    if (ev->state)
      break;
    uint64_t remain = timeout - (now - start);
    struct timespec ts;
    ts.tv_sec = remain / 1000;
    ts.tv_nsec = (remain % 1000) * 1000 * 1000;
    pthread_cond_timedwait(&ev->cv, &ev->mu, &ts);
    now = current_time_ms();
    if (now - start > timeout)
      break;
  }
  int res = ev->state;
  pthread_mutex_unlock(&ev->mu);
  return res;
}

struct thread_t {
  int created, call;
  event_t ready, done;
};

static struct thread_t threads[16];
static void execute_call(int call);
static int running;

static void* thr(void* arg)
{
  struct thread_t* th = (struct thread_t*)arg;
  for (;;) {
    event_wait(&th->ready);
    event_reset(&th->ready);
    execute_call(th->call);
    __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
    event_set(&th->done);
  }
  return 0;
}

static void execute_one(void)
{
  int i, call, thread;
  for (call = 0; call < 12; call++) {
    for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
         thread++) {
      struct thread_t* th = &threads[thread];
      if (!th->created) {
        th->created = 1;
        event_init(&th->ready);
        event_init(&th->done);
        event_set(&th->done);
        thread_start(thr, th);
      }
      if (!event_isset(&th->done))
        continue;
      event_reset(&th->done);
      th->call = call;
      __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
      event_set(&th->ready);
      event_timedwait(&th->done, 50);
      break;
    }
  }
  for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
    sleep_ms(1);
}

static void execute_one(void);

#define WAIT_FLAGS 0

static void loop(void)
{
  int iter = 0;
  for (;; iter++) {
    int pid = fork();
    if (pid < 0)
      exit(1);
    if (pid == 0) {
      execute_one();
      exit(0);
    }
    int status = 0;
    uint64_t start = current_time_ms();
    for (;;) {
      if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
        break;
      sleep_ms(1);
      if (current_time_ms() - start < 5000)
        continue;
      kill_and_wait(pid, &status);
      break;
    }
  }
}

uint64_t r[4] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff,
                 0xffffffffffffffff};

void execute_call(int call)
{
  intptr_t res = 0;
  switch (call) {
  case 0:
    res = syscall(SYS_socket, 0x1cul, 1ul, 0x84);
    if (res != -1)
      r[0] = res;
    break;
  case 1:
    syscall(SYS_connect, r[0], 0ul, 0ul);
    break;
  case 2:
    res = syscall(SYS_socket, 0x1cul, 1ul, 0x84);
    if (res != -1)
      r[1] = res;
    break;
  case 3:
    syscall(SYS_sendto, -1, 0ul, 0ul, 0ul, 0ul, 0ul);
    break;
  case 4:
    syscall(SYS_dup2, r[1], -1);
    break;
  case 5:
    res = syscall(SYS_dup2, -1, -1);
    if (res != -1)
      r[2] = res;
    break;
  case 6:
    res = syscall(SYS_dup2, -1, r[2]);
    if (res != -1)
      r[3] = res;
    break;
  case 7:
    syscall(SYS_sendmsg, r[3], 0ul, 0ul);
    break;
  case 8:
    syscall(SYS_sendto, -1, 0ul, 0ul, 0ul, 0ul, 0ul);
    break;
  case 9:
    memcpy((void*)0x20000100, "/dev/filemon\000", 13);
    syscall(SYS_openat, 0xffffffffffffff9cul, 0x20000100ul, 0ul, 0ul);
    break;
  case 10:
    syscall(SYS_rfork, 0x5000ul);
    break;
  case 11:
    *(uint32_t*)0x20000080 = 0x13;
    *(uint32_t*)0x20000084 = 0;
    *(uint32_t*)0x20000088 = 0;
    *(uint32_t*)0x2000008c = 0;
    *(uint32_t*)0x20000090 = -1;
    memset((void*)0x20000094, 0, 60);
    syscall(SYS_procctl, 0ul, 0, 6ul, 0x20000080ul);
    break;
  }
}
int main(void)
{
  syscall(SYS_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x1012ul, -1, 0ul);
  for (procid = 0; procid < 4; procid++) {
    if (fork() == 0) {
      loop();
    }
  }
  sleep(1000000);
  return 0;
}
EOF
mycc -o /tmp/syzkaller54 -Wall -Wextra -O0 /tmp/syzkaller54.c -l pthread ||
    exit 1

start=`date +%s`
while [ $((`date +%s` - start)) -lt 120 ]; do
	(cd /tmp; timeout 3m ./syzkaller54)
done

rm -rf /tmp/syzkaller54 /tmp/syzkaller54.c /tmp/syzkaller54.core \
    /tmp/syzkaller.??????
exit 0