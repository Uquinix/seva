#!/bin/sh

# panic: Counter goes negative
# cpuid = 8
# time = 1653397881
# KDB: stack backtrace:
# db_trace_self_wrapper() at db_trace_self_wrapper+0x2b/frame 0xfffffe014386fa40
# vpanic() at vpanic+0x17f/frame 0xfffffe014386fa90
# panic() at panic+0x43/frame 0xfffffe014386faf0
# sctp_sorecvmsg() at sctp_sorecvmsg+0xf8e/frame 0xfffffe014386fc10
# sctp_soreceive() at sctp_soreceive+0x196/frame 0xfffffe014386fe00
# soreceive() at soreceive+0x4b/frame 0xfffffe014386fe20
# soaio_process_sb() at soaio_process_sb+0x581/frame 0xfffffe014386feb0
# soaio_kproc_loop() at soaio_kproc_loop+0xa9/frame 0xfffffe014386fef0
# fork_exit() at fork_exit+0x80/frame 0xfffffe014386ff30
# fork_trampoline() at fork_trampoline+0xe/frame 0xfffffe014386ff30
# --- trap 0xc, rip = 0x8220e08da, rsp = 0x820a211b8, rbp = 0x820a211e0 ---
# KDB: enter: panic
# [ thread pid 78762 tid 931834 ]
# Stopped at      kdb_enter+0x32: movq    $0,0x1278fc3(%rip)
# db> x/s version
# FreeBSD 14.0-CURRENT #0 reap-n255780-cbbb27164fa: Tue May 24 13:42:53 CEST 2022
# pho@mercat1.netperf.freebsd.org:/var/tmp/deviant3/sys/amd64/compile/PHO
# db>

[ `uname -p` != "amd64" ] && exit 0

. ../default.cfg
cat > /tmp/syzkaller55.c <<EOF
// https://syzkaller.appspot.com/bug?id=ce7f451c017537296074d9203baaec292b311365
// autogenerated by syzkaller (https://github.com/google/syzkaller)
// Reported-by: syzbot+e256d42e9b390564530a@syzkaller.appspotmail.com

#define _GNU_SOURCE

#include <sys/types.h>

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

uint64_t r[3] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff};

void execute_one(void)
{
  intptr_t res = 0;
  res = syscall(SYS_socket, 0x1cul, 1ul, 0x84);
  if (res != -1)
    r[0] = res;
  *(uint8_t*)0x20000000 = 0x1c;
  *(uint8_t*)0x20000001 = 0x1c;
  *(uint16_t*)0x20000002 = htobe16(0x4e23 + procid * 4);
  *(uint32_t*)0x20000004 = 0;
  memset((void*)0x20000008, 0, 16);
  *(uint32_t*)0x20000018 = 0;
  syscall(SYS_bind, r[0], 0x20000000ul, 0x1cul);
  *(uint8_t*)0x20000080 = 0x1c;
  *(uint8_t*)0x20000081 = 0x1c;
  *(uint16_t*)0x20000082 = htobe16(0x4e23 + procid * 4);
  *(uint32_t*)0x20000084 = 0;
  *(uint64_t*)0x20000088 = htobe64(0);
  *(uint64_t*)0x20000090 = htobe64(1);
  *(uint32_t*)0x20000098 = 0;
  syscall(SYS_connect, r[0], 0x20000080ul, 0x1cul);
  *(uint32_t*)0x20000400 = r[0];
  *(uint64_t*)0x20000408 = 0;
  *(uint64_t*)0x20000410 = 0x20000040;
  memset((void*)0x20000040, 27, 1);
  *(uint64_t*)0x20000418 = 1;
  *(uint32_t*)0x20000420 = 0;
  *(uint32_t*)0x20000424 = 0;
  *(uint64_t*)0x20000428 = 0;
  *(uint32_t*)0x20000430 = 0;
  *(uint32_t*)0x20000434 = 0;
  *(uint64_t*)0x20000438 = 0;
  *(uint64_t*)0x20000440 = 0;
  *(uint64_t*)0x20000448 = 0;
  *(uint32_t*)0x20000450 = 0;
  *(uint32_t*)0x20000454 = 0;
  *(uint32_t*)0x20000458 = 0;
  *(uint64_t*)0x20000460 = 0;
  *(uint64_t*)0x20000468 = 0;
  *(uint64_t*)0x20000470 = 0;
  *(uint64_t*)0x20000478 = 0;
  *(uint64_t*)0x20000480 = 0;
  *(uint64_t*)0x20000488 = 0;
  *(uint64_t*)0x20000490 = 0;
  *(uint64_t*)0x20000498 = 0;
  syscall(SYS_aio_read, 0x20000400ul);
  memset((void*)0x200000c0, 89, 1);
  syscall(SYS_sendto, r[0], 0x200000c0ul, 1ul, 0ul, 0ul, 0ul);
  syscall(SYS_shutdown, r[0], 0ul);
  res = syscall(SYS_socket, 0x1cul, 5ul, 0x84);
  if (res != -1)
    r[1] = res;
  *(uint64_t*)0x200003c0 = 0;
  *(uint32_t*)0x200003c8 = 0;
  *(uint64_t*)0x200003d0 = 0x20000300;
  *(uint64_t*)0x20000300 = 0x20000200;
  memset((void*)0x20000200, 30, 1);
  *(uint64_t*)0x20000308 = 1;
  *(uint32_t*)0x200003d8 = 1;
  *(uint64_t*)0x200003e0 = 0;
  *(uint32_t*)0x200003e8 = 0;
  *(uint32_t*)0x200003ec = 0;
  syscall(SYS_sendmsg, r[0], 0x200003c0ul, 0ul);
  res = syscall(SYS_dup2, r[0], r[1]);
  if (res != -1)
    r[2] = res;
  *(uint32_t*)0x20000140 = 0;
  memcpy((void*)0x20000144, "\x0a\x00\x01\x00\x01", 5);
  syscall(SYS_setsockopt, r[2], 0x84, 0x901, 0x20000140ul, 0xaul);
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
mycc -o /tmp/syzkaller55 -Wall -Wextra -O0 /tmp/syzkaller55.c || exit 1

kldstat | grep -q sctp || kldload sctp.ko
start=`date +%s`
while [ $((`date +%s` - start)) -lt 120 ]; do
	(cd /tmp; timeout 3m ./syzkaller55)
done

rm -rf /tmp/syzkaller55 /tmp/syzkaller55.c /tmp/syzkaller55.core \
    /tmp/syzkaller.??????
exit 0