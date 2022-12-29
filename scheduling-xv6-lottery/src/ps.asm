
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "pstat.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 18 04 00 00    	sub    $0x418,%esp
    struct pstat p;
    if (getpinfo(&p) < 0)
  16:	8d 9d e8 fb ff ff    	lea    -0x418(%ebp),%ebx
  1c:	53                   	push   %ebx
  1d:	e8 bb 02 00 00       	call   2dd <getpinfo>
  22:	83 c4 10             	add    $0x10,%esp
  25:	85 c0                	test   %eax,%eax
  27:	78 48                	js     71 <main+0x71>
  29:	8d b5 e8 fc ff ff    	lea    -0x318(%ebp),%esi
  2f:	eb 0a                	jmp    3b <main+0x3b>
  31:	8d 76 00             	lea    0x0(%esi),%esi
    {
        printf(2, "getpinfo() error.");
        exit();
    }

    for (int i = 0; i < NPROC; i++)
  34:	83 c3 04             	add    $0x4,%ebx
  37:	39 f3                	cmp    %esi,%ebx
  39:	74 31                	je     6c <main+0x6c>
    {
        if (p.inuse[i])
  3b:	8b 03                	mov    (%ebx),%eax
  3d:	85 c0                	test   %eax,%eax
  3f:	74 f3                	je     34 <main+0x34>
            printf(1, "pid: %d  tickets: %d  ticks: %d\n", p.pid[i], p.tickets[i], p.ticks[i]);
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	ff b3 00 03 00 00    	pushl  0x300(%ebx)
  4a:	ff b3 00 01 00 00    	pushl  0x100(%ebx)
  50:	ff b3 00 02 00 00    	pushl  0x200(%ebx)
  56:	68 90 06 00 00       	push   $0x690
  5b:	6a 01                	push   $0x1
  5d:	e8 0e 03 00 00       	call   370 <printf>
  62:	83 c4 20             	add    $0x20,%esp
    for (int i = 0; i < NPROC; i++)
  65:	83 c3 04             	add    $0x4,%ebx
  68:	39 f3                	cmp    %esi,%ebx
  6a:	75 cf                	jne    3b <main+0x3b>
    }

    exit();
  6c:	e8 c4 01 00 00       	call   235 <exit>
        printf(2, "getpinfo() error.");
  71:	52                   	push   %edx
  72:	52                   	push   %edx
  73:	68 7c 06 00 00       	push   $0x67c
  78:	6a 02                	push   $0x2
  7a:	e8 f1 02 00 00       	call   370 <printf>
        exit();
  7f:	e8 b1 01 00 00       	call   235 <exit>

00000084 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8e:	31 c0                	xor    %eax,%eax
  90:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  93:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  96:	40                   	inc    %eax
  97:	84 d2                	test   %dl,%dl
  99:	75 f5                	jne    90 <strcpy+0xc>
    ;
  return os;
}
  9b:	89 c8                	mov    %ecx,%eax
  9d:	5b                   	pop    %ebx
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  aa:	0f b6 03             	movzbl (%ebx),%eax
  ad:	0f b6 0a             	movzbl (%edx),%ecx
  b0:	84 c0                	test   %al,%al
  b2:	75 10                	jne    c4 <strcmp+0x24>
  b4:	eb 1a                	jmp    d0 <strcmp+0x30>
  b6:	66 90                	xchg   %ax,%ax
    p++, q++;
  b8:	43                   	inc    %ebx
  b9:	42                   	inc    %edx
  while(*p && *p == *q)
  ba:	0f b6 03             	movzbl (%ebx),%eax
  bd:	0f b6 0a             	movzbl (%edx),%ecx
  c0:	84 c0                	test   %al,%al
  c2:	74 0c                	je     d0 <strcmp+0x30>
  c4:	38 c8                	cmp    %cl,%al
  c6:	74 f0                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  c8:	29 c8                	sub    %ecx,%eax
}
  ca:	5b                   	pop    %ebx
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  d2:	29 c8                	sub    %ecx,%eax
}
  d4:	5b                   	pop    %ebx
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	90                   	nop

000000d8 <strlen>:

uint
strlen(const char *s)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  de:	80 3a 00             	cmpb   $0x0,(%edx)
  e1:	74 15                	je     f8 <strlen+0x20>
  e3:	31 c0                	xor    %eax,%eax
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  e8:	40                   	inc    %eax
  e9:	89 c1                	mov    %eax,%ecx
  eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ef:	75 f7                	jne    e8 <strlen+0x10>
    ;
  return n;
}
  f1:	89 c8                	mov    %ecx,%eax
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  f8:	31 c9                	xor    %ecx,%ecx
}
  fa:	89 c8                	mov    %ecx,%eax
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    
  fe:	66 90                	xchg   %ax,%ax

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 104:	8b 7d 08             	mov    0x8(%ebp),%edi
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	fc                   	cld    
 10e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	5f                   	pop    %edi
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    
 116:	66 90                	xchg   %ax,%ax

00000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 121:	8a 10                	mov    (%eax),%dl
 123:	84 d2                	test   %dl,%dl
 125:	75 0c                	jne    133 <strchr+0x1b>
 127:	eb 13                	jmp    13c <strchr+0x24>
 129:	8d 76 00             	lea    0x0(%esi),%esi
 12c:	40                   	inc    %eax
 12d:	8a 10                	mov    (%eax),%dl
 12f:	84 d2                	test   %dl,%dl
 131:	74 09                	je     13c <strchr+0x24>
    if(*s == c)
 133:	38 d1                	cmp    %dl,%cl
 135:	75 f5                	jne    12c <strchr+0x14>
      return (char*)s;
  return 0;
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    
 139:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 13c:	31 c0                	xor    %eax,%eax
}
 13e:	5d                   	pop    %ebp
 13f:	c3                   	ret    

00000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
 146:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 149:	8b 75 08             	mov    0x8(%ebp),%esi
 14c:	bb 01 00 00 00       	mov    $0x1,%ebx
 151:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 153:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 156:	eb 20                	jmp    178 <gets+0x38>
    cc = read(0, &c, 1);
 158:	50                   	push   %eax
 159:	6a 01                	push   $0x1
 15b:	57                   	push   %edi
 15c:	6a 00                	push   $0x0
 15e:	e8 ea 00 00 00       	call   24d <read>
    if(cc < 1)
 163:	83 c4 10             	add    $0x10,%esp
 166:	85 c0                	test   %eax,%eax
 168:	7e 16                	jle    180 <gets+0x40>
      break;
    buf[i++] = c;
 16a:	8a 45 e7             	mov    -0x19(%ebp),%al
 16d:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 16f:	46                   	inc    %esi
 170:	3c 0a                	cmp    $0xa,%al
 172:	74 0c                	je     180 <gets+0x40>
 174:	3c 0d                	cmp    $0xd,%al
 176:	74 08                	je     180 <gets+0x40>
  for(i=0; i+1 < max; ){
 178:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 17b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 17e:	7f d8                	jg     158 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 180:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8d 65 f4             	lea    -0xc(%ebp),%esp
 189:	5b                   	pop    %ebx
 18a:	5e                   	pop    %esi
 18b:	5f                   	pop    %edi
 18c:	5d                   	pop    %ebp
 18d:	c3                   	ret    
 18e:	66 90                	xchg   %ax,%ax

00000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	6a 00                	push   $0x0
 19a:	ff 75 08             	pushl  0x8(%ebp)
 19d:	e8 d3 00 00 00       	call   275 <open>
  if(fd < 0)
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	85 c0                	test   %eax,%eax
 1a7:	78 27                	js     1d0 <stat+0x40>
 1a9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 0c             	pushl  0xc(%ebp)
 1b1:	50                   	push   %eax
 1b2:	e8 d6 00 00 00       	call   28d <fstat>
 1b7:	89 c6                	mov    %eax,%esi
  close(fd);
 1b9:	89 1c 24             	mov    %ebx,(%esp)
 1bc:	e8 9c 00 00 00       	call   25d <close>
  return r;
 1c1:	83 c4 10             	add    $0x10,%esp
}
 1c4:	89 f0                	mov    %esi,%eax
 1c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c9:	5b                   	pop    %ebx
 1ca:	5e                   	pop    %esi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d5:	eb ed                	jmp    1c4 <stat+0x34>
 1d7:	90                   	nop

000001d8 <atoi>:

int
atoi(const char *s)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	53                   	push   %ebx
 1dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1df:	0f be 01             	movsbl (%ecx),%eax
 1e2:	8d 50 d0             	lea    -0x30(%eax),%edx
 1e5:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1e8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1ed:	77 16                	ja     205 <atoi+0x2d>
 1ef:	90                   	nop
    n = n*10 + *s++ - '0';
 1f0:	41                   	inc    %ecx
 1f1:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1f4:	01 d2                	add    %edx,%edx
 1f6:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1fa:	0f be 01             	movsbl (%ecx),%eax
 1fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 200:	80 fb 09             	cmp    $0x9,%bl
 203:	76 eb                	jbe    1f0 <atoi+0x18>
  return n;
}
 205:	89 d0                	mov    %edx,%eax
 207:	5b                   	pop    %ebx
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    
 20a:	66 90                	xchg   %ax,%ax

0000020c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	57                   	push   %edi
 210:	56                   	push   %esi
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	8b 75 0c             	mov    0xc(%ebp),%esi
 217:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21a:	85 d2                	test   %edx,%edx
 21c:	7e 0b                	jle    229 <memmove+0x1d>
 21e:	01 c2                	add    %eax,%edx
  dst = vdst;
 220:	89 c7                	mov    %eax,%edi
 222:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 224:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 225:	39 fa                	cmp    %edi,%edx
 227:	75 fb                	jne    224 <memmove+0x18>
  return vdst;
}
 229:	5e                   	pop    %esi
 22a:	5f                   	pop    %edi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    

0000022d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22d:	b8 01 00 00 00       	mov    $0x1,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <exit>:
SYSCALL(exit)
 235:	b8 02 00 00 00       	mov    $0x2,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <wait>:
SYSCALL(wait)
 23d:	b8 03 00 00 00       	mov    $0x3,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <pipe>:
SYSCALL(pipe)
 245:	b8 04 00 00 00       	mov    $0x4,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <read>:
SYSCALL(read)
 24d:	b8 05 00 00 00       	mov    $0x5,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <write>:
SYSCALL(write)
 255:	b8 10 00 00 00       	mov    $0x10,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <close>:
SYSCALL(close)
 25d:	b8 15 00 00 00       	mov    $0x15,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <kill>:
SYSCALL(kill)
 265:	b8 06 00 00 00       	mov    $0x6,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <exec>:
SYSCALL(exec)
 26d:	b8 07 00 00 00       	mov    $0x7,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <open>:
SYSCALL(open)
 275:	b8 0f 00 00 00       	mov    $0xf,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <mknod>:
SYSCALL(mknod)
 27d:	b8 11 00 00 00       	mov    $0x11,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <unlink>:
SYSCALL(unlink)
 285:	b8 12 00 00 00       	mov    $0x12,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <fstat>:
SYSCALL(fstat)
 28d:	b8 08 00 00 00       	mov    $0x8,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <link>:
SYSCALL(link)
 295:	b8 13 00 00 00       	mov    $0x13,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <mkdir>:
SYSCALL(mkdir)
 29d:	b8 14 00 00 00       	mov    $0x14,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <chdir>:
SYSCALL(chdir)
 2a5:	b8 09 00 00 00       	mov    $0x9,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <dup>:
SYSCALL(dup)
 2ad:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <getpid>:
SYSCALL(getpid)
 2b5:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <sbrk>:
SYSCALL(sbrk)
 2bd:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <sleep>:
SYSCALL(sleep)
 2c5:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <uptime>:
SYSCALL(uptime)
 2cd:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <settickets>:
SYSCALL(settickets)
 2d5:	b8 16 00 00 00       	mov    $0x16,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <getpinfo>:
SYSCALL(getpinfo)
 2dd:	b8 17 00 00 00       	mov    $0x17,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    
 2e5:	66 90                	xchg   %ax,%ax
 2e7:	90                   	nop

000002e8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	57                   	push   %edi
 2ec:	56                   	push   %esi
 2ed:	53                   	push   %ebx
 2ee:	83 ec 3c             	sub    $0x3c,%esp
 2f1:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2f4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2f7:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2fc:	85 db                	test   %ebx,%ebx
 2fe:	74 04                	je     304 <printint+0x1c>
 300:	85 d2                	test   %edx,%edx
 302:	78 68                	js     36c <printint+0x84>
  neg = 0;
 304:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 30b:	31 ff                	xor    %edi,%edi
 30d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 310:	89 c8                	mov    %ecx,%eax
 312:	31 d2                	xor    %edx,%edx
 314:	f7 75 c4             	divl   -0x3c(%ebp)
 317:	89 fb                	mov    %edi,%ebx
 319:	8d 7f 01             	lea    0x1(%edi),%edi
 31c:	8a 92 b8 06 00 00    	mov    0x6b8(%edx),%dl
 322:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 326:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 329:	89 c1                	mov    %eax,%ecx
 32b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 32e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 331:	76 dd                	jbe    310 <printint+0x28>
  if(neg)
 333:	8b 4d 08             	mov    0x8(%ebp),%ecx
 336:	85 c9                	test   %ecx,%ecx
 338:	74 09                	je     343 <printint+0x5b>
    buf[i++] = '-';
 33a:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 33f:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 341:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 343:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 347:	8b 7d bc             	mov    -0x44(%ebp),%edi
 34a:	eb 03                	jmp    34f <printint+0x67>
 34c:	8a 13                	mov    (%ebx),%dl
 34e:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 34f:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 352:	50                   	push   %eax
 353:	6a 01                	push   $0x1
 355:	56                   	push   %esi
 356:	57                   	push   %edi
 357:	e8 f9 fe ff ff       	call   255 <write>
  while(--i >= 0)
 35c:	83 c4 10             	add    $0x10,%esp
 35f:	39 de                	cmp    %ebx,%esi
 361:	75 e9                	jne    34c <printint+0x64>
}
 363:	8d 65 f4             	lea    -0xc(%ebp),%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    
 36b:	90                   	nop
    x = -xx;
 36c:	f7 d9                	neg    %ecx
 36e:	eb 9b                	jmp    30b <printint+0x23>

00000370 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
 376:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 379:	8b 75 0c             	mov    0xc(%ebp),%esi
 37c:	8a 1e                	mov    (%esi),%bl
 37e:	84 db                	test   %bl,%bl
 380:	0f 84 a3 00 00 00    	je     429 <printf+0xb9>
 386:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 387:	8d 45 10             	lea    0x10(%ebp),%eax
 38a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 38d:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 38f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 392:	eb 29                	jmp    3bd <printf+0x4d>
 394:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 397:	83 f8 25             	cmp    $0x25,%eax
 39a:	0f 84 94 00 00 00    	je     434 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 3a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3a3:	50                   	push   %eax
 3a4:	6a 01                	push   $0x1
 3a6:	57                   	push   %edi
 3a7:	ff 75 08             	pushl  0x8(%ebp)
 3aa:	e8 a6 fe ff ff       	call   255 <write>
        putc(fd, c);
 3af:	83 c4 10             	add    $0x10,%esp
 3b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 3b5:	46                   	inc    %esi
 3b6:	8a 5e ff             	mov    -0x1(%esi),%bl
 3b9:	84 db                	test   %bl,%bl
 3bb:	74 6c                	je     429 <printf+0xb9>
    c = fmt[i] & 0xff;
 3bd:	0f be cb             	movsbl %bl,%ecx
 3c0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c3:	85 d2                	test   %edx,%edx
 3c5:	74 cd                	je     394 <printf+0x24>
      }
    } else if(state == '%'){
 3c7:	83 fa 25             	cmp    $0x25,%edx
 3ca:	75 e9                	jne    3b5 <printf+0x45>
      if(c == 'd'){
 3cc:	83 f8 64             	cmp    $0x64,%eax
 3cf:	0f 84 97 00 00 00    	je     46c <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3d5:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3db:	83 f9 70             	cmp    $0x70,%ecx
 3de:	74 60                	je     440 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3e0:	83 f8 73             	cmp    $0x73,%eax
 3e3:	0f 84 8f 00 00 00    	je     478 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3e9:	83 f8 63             	cmp    $0x63,%eax
 3ec:	0f 84 d6 00 00 00    	je     4c8 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3f2:	83 f8 25             	cmp    $0x25,%eax
 3f5:	0f 84 c1 00 00 00    	je     4bc <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3fb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3ff:	50                   	push   %eax
 400:	6a 01                	push   $0x1
 402:	57                   	push   %edi
 403:	ff 75 08             	pushl  0x8(%ebp)
 406:	e8 4a fe ff ff       	call   255 <write>
        putc(fd, c);
 40b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 40e:	83 c4 0c             	add    $0xc,%esp
 411:	6a 01                	push   $0x1
 413:	57                   	push   %edi
 414:	ff 75 08             	pushl  0x8(%ebp)
 417:	e8 39 fe ff ff       	call   255 <write>
        putc(fd, c);
 41c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 41f:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 421:	46                   	inc    %esi
 422:	8a 5e ff             	mov    -0x1(%esi),%bl
 425:	84 db                	test   %bl,%bl
 427:	75 94                	jne    3bd <printf+0x4d>
    }
  }
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 434:	ba 25 00 00 00       	mov    $0x25,%edx
 439:	e9 77 ff ff ff       	jmp    3b5 <printf+0x45>
 43e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 00                	push   $0x0
 445:	b9 10 00 00 00       	mov    $0x10,%ecx
 44a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 44d:	8b 13                	mov    (%ebx),%edx
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	e8 91 fe ff ff       	call   2e8 <printint>
        ap++;
 457:	89 d8                	mov    %ebx,%eax
 459:	83 c0 04             	add    $0x4,%eax
 45c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 45f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 462:	31 d2                	xor    %edx,%edx
        ap++;
 464:	e9 4c ff ff ff       	jmp    3b5 <printf+0x45>
 469:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 46c:	83 ec 0c             	sub    $0xc,%esp
 46f:	6a 01                	push   $0x1
 471:	b9 0a 00 00 00       	mov    $0xa,%ecx
 476:	eb d2                	jmp    44a <printf+0xda>
        s = (char*)*ap;
 478:	8b 45 d0             	mov    -0x30(%ebp),%eax
 47b:	8b 18                	mov    (%eax),%ebx
        ap++;
 47d:	83 c0 04             	add    $0x4,%eax
 480:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 483:	85 db                	test   %ebx,%ebx
 485:	74 65                	je     4ec <printf+0x17c>
        while(*s != 0){
 487:	8a 03                	mov    (%ebx),%al
 489:	84 c0                	test   %al,%al
 48b:	74 70                	je     4fd <printf+0x18d>
 48d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 490:	89 de                	mov    %ebx,%esi
 492:	8b 5d 08             	mov    0x8(%ebp),%ebx
 495:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 498:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 49b:	50                   	push   %eax
 49c:	6a 01                	push   $0x1
 49e:	57                   	push   %edi
 49f:	53                   	push   %ebx
 4a0:	e8 b0 fd ff ff       	call   255 <write>
          s++;
 4a5:	46                   	inc    %esi
        while(*s != 0){
 4a6:	8a 06                	mov    (%esi),%al
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	84 c0                	test   %al,%al
 4ad:	75 e9                	jne    498 <printf+0x128>
 4af:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	e9 fc fe ff ff       	jmp    3b5 <printf+0x45>
 4b9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 4bc:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4bf:	52                   	push   %edx
 4c0:	e9 4c ff ff ff       	jmp    411 <printf+0xa1>
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4c8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4cb:	8b 03                	mov    (%ebx),%eax
 4cd:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d0:	51                   	push   %ecx
 4d1:	6a 01                	push   $0x1
 4d3:	57                   	push   %edi
 4d4:	ff 75 08             	pushl  0x8(%ebp)
 4d7:	e8 79 fd ff ff       	call   255 <write>
        ap++;
 4dc:	83 c3 04             	add    $0x4,%ebx
 4df:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4e2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e5:	31 d2                	xor    %edx,%edx
 4e7:	e9 c9 fe ff ff       	jmp    3b5 <printf+0x45>
          s = "(null)";
 4ec:	bb b1 06 00 00       	mov    $0x6b1,%ebx
        while(*s != 0){
 4f1:	b0 28                	mov    $0x28,%al
 4f3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4f6:	89 de                	mov    %ebx,%esi
 4f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4fb:	eb 9b                	jmp    498 <printf+0x128>
      state = 0;
 4fd:	31 d2                	xor    %edx,%edx
 4ff:	e9 b1 fe ff ff       	jmp    3b5 <printf+0x45>

00000504 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 504:	55                   	push   %ebp
 505:	89 e5                	mov    %esp,%ebp
 507:	57                   	push   %edi
 508:	56                   	push   %esi
 509:	53                   	push   %ebx
 50a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 50d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 510:	a1 58 09 00 00       	mov    0x958,%eax
 515:	8b 10                	mov    (%eax),%edx
 517:	39 c8                	cmp    %ecx,%eax
 519:	73 11                	jae    52c <free+0x28>
 51b:	90                   	nop
 51c:	39 d1                	cmp    %edx,%ecx
 51e:	72 14                	jb     534 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 520:	39 d0                	cmp    %edx,%eax
 522:	73 10                	jae    534 <free+0x30>
{
 524:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 526:	8b 10                	mov    (%eax),%edx
 528:	39 c8                	cmp    %ecx,%eax
 52a:	72 f0                	jb     51c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 52c:	39 d0                	cmp    %edx,%eax
 52e:	72 f4                	jb     524 <free+0x20>
 530:	39 d1                	cmp    %edx,%ecx
 532:	73 f0                	jae    524 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 534:	8b 73 fc             	mov    -0x4(%ebx),%esi
 537:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 53a:	39 fa                	cmp    %edi,%edx
 53c:	74 1a                	je     558 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 53e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 541:	8b 50 04             	mov    0x4(%eax),%edx
 544:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 547:	39 f1                	cmp    %esi,%ecx
 549:	74 24                	je     56f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 54b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 54d:	a3 58 09 00 00       	mov    %eax,0x958
}
 552:	5b                   	pop    %ebx
 553:	5e                   	pop    %esi
 554:	5f                   	pop    %edi
 555:	5d                   	pop    %ebp
 556:	c3                   	ret    
 557:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 558:	03 72 04             	add    0x4(%edx),%esi
 55b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 55e:	8b 10                	mov    (%eax),%edx
 560:	8b 12                	mov    (%edx),%edx
 562:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 565:	8b 50 04             	mov    0x4(%eax),%edx
 568:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 56b:	39 f1                	cmp    %esi,%ecx
 56d:	75 dc                	jne    54b <free+0x47>
    p->s.size += bp->s.size;
 56f:	03 53 fc             	add    -0x4(%ebx),%edx
 572:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 575:	8b 53 f8             	mov    -0x8(%ebx),%edx
 578:	89 10                	mov    %edx,(%eax)
  freep = p;
 57a:	a3 58 09 00 00       	mov    %eax,0x958
}
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    

00000584 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	56                   	push   %esi
 589:	53                   	push   %ebx
 58a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	8d 70 07             	lea    0x7(%eax),%esi
 593:	c1 ee 03             	shr    $0x3,%esi
 596:	46                   	inc    %esi
  if((prevp = freep) == 0){
 597:	8b 3d 58 09 00 00    	mov    0x958,%edi
 59d:	85 ff                	test   %edi,%edi
 59f:	0f 84 a3 00 00 00    	je     648 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a5:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 5a7:	8b 48 04             	mov    0x4(%eax),%ecx
 5aa:	39 f1                	cmp    %esi,%ecx
 5ac:	73 67                	jae    615 <malloc+0x91>
 5ae:	89 f3                	mov    %esi,%ebx
 5b0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 5b6:	0f 82 80 00 00 00    	jb     63c <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 5bc:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 5c3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 5c6:	eb 11                	jmp    5d9 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c8:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5ca:	8b 4a 04             	mov    0x4(%edx),%ecx
 5cd:	39 f1                	cmp    %esi,%ecx
 5cf:	73 4b                	jae    61c <malloc+0x98>
 5d1:	8b 3d 58 09 00 00    	mov    0x958,%edi
 5d7:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5d9:	39 c7                	cmp    %eax,%edi
 5db:	75 eb                	jne    5c8 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5dd:	83 ec 0c             	sub    $0xc,%esp
 5e0:	ff 75 e4             	pushl  -0x1c(%ebp)
 5e3:	e8 d5 fc ff ff       	call   2bd <sbrk>
  if(p == (char*)-1)
 5e8:	83 c4 10             	add    $0x10,%esp
 5eb:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ee:	74 1b                	je     60b <malloc+0x87>
  hp->s.size = nu;
 5f0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5f3:	83 ec 0c             	sub    $0xc,%esp
 5f6:	83 c0 08             	add    $0x8,%eax
 5f9:	50                   	push   %eax
 5fa:	e8 05 ff ff ff       	call   504 <free>
  return freep;
 5ff:	a1 58 09 00 00       	mov    0x958,%eax
      if((p = morecore(nunits)) == 0)
 604:	83 c4 10             	add    $0x10,%esp
 607:	85 c0                	test   %eax,%eax
 609:	75 bd                	jne    5c8 <malloc+0x44>
        return 0;
 60b:	31 c0                	xor    %eax,%eax
  }
}
 60d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 610:	5b                   	pop    %ebx
 611:	5e                   	pop    %esi
 612:	5f                   	pop    %edi
 613:	5d                   	pop    %ebp
 614:	c3                   	ret    
    if(p->s.size >= nunits){
 615:	89 c2                	mov    %eax,%edx
 617:	89 f8                	mov    %edi,%eax
 619:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 61c:	39 ce                	cmp    %ecx,%esi
 61e:	74 54                	je     674 <malloc+0xf0>
        p->s.size -= nunits;
 620:	29 f1                	sub    %esi,%ecx
 622:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 625:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 628:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 62b:	a3 58 09 00 00       	mov    %eax,0x958
      return (void*)(p + 1);
 630:	8d 42 08             	lea    0x8(%edx),%eax
}
 633:	8d 65 f4             	lea    -0xc(%ebp),%esp
 636:	5b                   	pop    %ebx
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
 63b:	90                   	nop
 63c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 641:	e9 76 ff ff ff       	jmp    5bc <malloc+0x38>
 646:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 648:	c7 05 58 09 00 00 5c 	movl   $0x95c,0x958
 64f:	09 00 00 
 652:	c7 05 5c 09 00 00 5c 	movl   $0x95c,0x95c
 659:	09 00 00 
    base.s.size = 0;
 65c:	c7 05 60 09 00 00 00 	movl   $0x0,0x960
 663:	00 00 00 
 666:	bf 5c 09 00 00       	mov    $0x95c,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66b:	89 f8                	mov    %edi,%eax
 66d:	e9 3c ff ff ff       	jmp    5ae <malloc+0x2a>
 672:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 674:	8b 0a                	mov    (%edx),%ecx
 676:	89 08                	mov    %ecx,(%eax)
 678:	eb b1                	jmp    62b <malloc+0xa7>
