
_test_1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	50                   	push   %eax
    int rc1 = fork();
   f:	e8 29 02 00 00       	call   23d <fork>

    if (rc1 == 0)
  14:	85 c0                	test   %eax,%eax
  16:	74 45                	je     5d <main+0x5d>
    {
        settickets(30);
        sleep(50);
    }
    else if (rc1 > 0)
  18:	7f 14                	jg     2e <main+0x2e>
        }
    }

    for (int i = 0; i < 3; i++)
    {
        wait();
  1a:	e8 2e 02 00 00       	call   24d <wait>
  1f:	e8 29 02 00 00       	call   24d <wait>
  24:	e8 24 02 00 00       	call   24d <wait>
    }

    exit();
  29:	e8 17 02 00 00       	call   245 <exit>
        int rc2 = fork();
  2e:	e8 0a 02 00 00       	call   23d <fork>
        if (rc2 == 0)
  33:	85 c0                	test   %eax,%eax
  35:	74 41                	je     78 <main+0x78>
        else if (rc2 > 0)
  37:	7e e1                	jle    1a <main+0x1a>
            int rc3 = fork();
  39:	e8 ff 01 00 00       	call   23d <fork>
            if (rc3 == 0)
  3e:	85 c0                	test   %eax,%eax
  40:	75 d8                	jne    1a <main+0x1a>
                settickets(10);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	6a 0a                	push   $0xa
  47:	e8 99 02 00 00       	call   2e5 <settickets>
                sleep(50);
  4c:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  53:	e8 7d 02 00 00       	call   2d5 <sleep>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	eb bd                	jmp    1a <main+0x1a>
        settickets(30);
  5d:	83 ec 0c             	sub    $0xc,%esp
  60:	6a 1e                	push   $0x1e
  62:	e8 7e 02 00 00       	call   2e5 <settickets>
        sleep(50);
  67:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  6e:	e8 62 02 00 00       	call   2d5 <sleep>
  73:	83 c4 10             	add    $0x10,%esp
  76:	eb a2                	jmp    1a <main+0x1a>
            settickets(20);
  78:	83 ec 0c             	sub    $0xc,%esp
  7b:	6a 14                	push   $0x14
  7d:	e8 63 02 00 00       	call   2e5 <settickets>
            sleep(50);
  82:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  89:	e8 47 02 00 00       	call   2d5 <sleep>
  8e:	83 c4 10             	add    $0x10,%esp
  91:	eb 87                	jmp    1a <main+0x1a>
  93:	90                   	nop

00000094 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	53                   	push   %ebx
  98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9e:	31 c0                	xor    %eax,%eax
  a0:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  a3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a6:	40                   	inc    %eax
  a7:	84 d2                	test   %dl,%dl
  a9:	75 f5                	jne    a0 <strcpy+0xc>
    ;
  return os;
}
  ab:	89 c8                	mov    %ecx,%eax
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	0f b6 03             	movzbl (%ebx),%eax
  bd:	0f b6 0a             	movzbl (%edx),%ecx
  c0:	84 c0                	test   %al,%al
  c2:	75 10                	jne    d4 <strcmp+0x24>
  c4:	eb 1a                	jmp    e0 <strcmp+0x30>
  c6:	66 90                	xchg   %ax,%ax
    p++, q++;
  c8:	43                   	inc    %ebx
  c9:	42                   	inc    %edx
  while(*p && *p == *q)
  ca:	0f b6 03             	movzbl (%ebx),%eax
  cd:	0f b6 0a             	movzbl (%edx),%ecx
  d0:	84 c0                	test   %al,%al
  d2:	74 0c                	je     e0 <strcmp+0x30>
  d4:	38 c8                	cmp    %cl,%al
  d6:	74 f0                	je     c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  d8:	29 c8                	sub    %ecx,%eax
}
  da:	5b                   	pop    %ebx
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  e2:	29 c8                	sub    %ecx,%eax
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop

000000e8 <strlen>:

uint
strlen(const char *s)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ee:	80 3a 00             	cmpb   $0x0,(%edx)
  f1:	74 15                	je     108 <strlen+0x20>
  f3:	31 c0                	xor    %eax,%eax
  f5:	8d 76 00             	lea    0x0(%esi),%esi
  f8:	40                   	inc    %eax
  f9:	89 c1                	mov    %eax,%ecx
  fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ff:	75 f7                	jne    f8 <strlen+0x10>
    ;
  return n;
}
 101:	89 c8                	mov    %ecx,%eax
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 108:	31 c9                	xor    %ecx,%ecx
}
 10a:	89 c8                	mov    %ecx,%eax
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    
 10e:	66 90                	xchg   %ax,%ax

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 114:	8b 7d 08             	mov    0x8(%ebp),%edi
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	fc                   	cld    
 11e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	5f                   	pop    %edi
 124:	5d                   	pop    %ebp
 125:	c3                   	ret    
 126:	66 90                	xchg   %ax,%ax

00000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 131:	8a 10                	mov    (%eax),%dl
 133:	84 d2                	test   %dl,%dl
 135:	75 0c                	jne    143 <strchr+0x1b>
 137:	eb 13                	jmp    14c <strchr+0x24>
 139:	8d 76 00             	lea    0x0(%esi),%esi
 13c:	40                   	inc    %eax
 13d:	8a 10                	mov    (%eax),%dl
 13f:	84 d2                	test   %dl,%dl
 141:	74 09                	je     14c <strchr+0x24>
    if(*s == c)
 143:	38 d1                	cmp    %dl,%cl
 145:	75 f5                	jne    13c <strchr+0x14>
      return (char*)s;
  return 0;
}
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    
 149:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 14c:	31 c0                	xor    %eax,%eax
}
 14e:	5d                   	pop    %ebp
 14f:	c3                   	ret    

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 159:	8b 75 08             	mov    0x8(%ebp),%esi
 15c:	bb 01 00 00 00       	mov    $0x1,%ebx
 161:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 163:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 166:	eb 20                	jmp    188 <gets+0x38>
    cc = read(0, &c, 1);
 168:	50                   	push   %eax
 169:	6a 01                	push   $0x1
 16b:	57                   	push   %edi
 16c:	6a 00                	push   $0x0
 16e:	e8 ea 00 00 00       	call   25d <read>
    if(cc < 1)
 173:	83 c4 10             	add    $0x10,%esp
 176:	85 c0                	test   %eax,%eax
 178:	7e 16                	jle    190 <gets+0x40>
      break;
    buf[i++] = c;
 17a:	8a 45 e7             	mov    -0x19(%ebp),%al
 17d:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 17f:	46                   	inc    %esi
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 0c                	je     190 <gets+0x40>
 184:	3c 0d                	cmp    $0xd,%al
 186:	74 08                	je     190 <gets+0x40>
  for(i=0; i+1 < max; ){
 188:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 18b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18e:	7f d8                	jg     168 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 190:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8d 65 f4             	lea    -0xc(%ebp),%esp
 199:	5b                   	pop    %ebx
 19a:	5e                   	pop    %esi
 19b:	5f                   	pop    %edi
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    
 19e:	66 90                	xchg   %ax,%ax

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	6a 00                	push   $0x0
 1aa:	ff 75 08             	pushl  0x8(%ebp)
 1ad:	e8 d3 00 00 00       	call   285 <open>
  if(fd < 0)
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	78 27                	js     1e0 <stat+0x40>
 1b9:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1bb:	83 ec 08             	sub    $0x8,%esp
 1be:	ff 75 0c             	pushl  0xc(%ebp)
 1c1:	50                   	push   %eax
 1c2:	e8 d6 00 00 00       	call   29d <fstat>
 1c7:	89 c6                	mov    %eax,%esi
  close(fd);
 1c9:	89 1c 24             	mov    %ebx,(%esp)
 1cc:	e8 9c 00 00 00       	call   26d <close>
  return r;
 1d1:	83 c4 10             	add    $0x10,%esp
}
 1d4:	89 f0                	mov    %esi,%eax
 1d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e5:	eb ed                	jmp    1d4 <stat+0x34>
 1e7:	90                   	nop

000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	53                   	push   %ebx
 1ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ef:	0f be 01             	movsbl (%ecx),%eax
 1f2:	8d 50 d0             	lea    -0x30(%eax),%edx
 1f5:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1f8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1fd:	77 16                	ja     215 <atoi+0x2d>
 1ff:	90                   	nop
    n = n*10 + *s++ - '0';
 200:	41                   	inc    %ecx
 201:	8d 14 92             	lea    (%edx,%edx,4),%edx
 204:	01 d2                	add    %edx,%edx
 206:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 20a:	0f be 01             	movsbl (%ecx),%eax
 20d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 210:	80 fb 09             	cmp    $0x9,%bl
 213:	76 eb                	jbe    200 <atoi+0x18>
  return n;
}
 215:	89 d0                	mov    %edx,%eax
 217:	5b                   	pop    %ebx
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    
 21a:	66 90                	xchg   %ax,%ax

0000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	57                   	push   %edi
 220:	56                   	push   %esi
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	8b 75 0c             	mov    0xc(%ebp),%esi
 227:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22a:	85 d2                	test   %edx,%edx
 22c:	7e 0b                	jle    239 <memmove+0x1d>
 22e:	01 c2                	add    %eax,%edx
  dst = vdst;
 230:	89 c7                	mov    %eax,%edi
 232:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 234:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 235:	39 fa                	cmp    %edi,%edx
 237:	75 fb                	jne    234 <memmove+0x18>
  return vdst;
}
 239:	5e                   	pop    %esi
 23a:	5f                   	pop    %edi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    

0000023d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23d:	b8 01 00 00 00       	mov    $0x1,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <exit>:
SYSCALL(exit)
 245:	b8 02 00 00 00       	mov    $0x2,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <wait>:
SYSCALL(wait)
 24d:	b8 03 00 00 00       	mov    $0x3,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <pipe>:
SYSCALL(pipe)
 255:	b8 04 00 00 00       	mov    $0x4,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <read>:
SYSCALL(read)
 25d:	b8 05 00 00 00       	mov    $0x5,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <write>:
SYSCALL(write)
 265:	b8 10 00 00 00       	mov    $0x10,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <close>:
SYSCALL(close)
 26d:	b8 15 00 00 00       	mov    $0x15,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <kill>:
SYSCALL(kill)
 275:	b8 06 00 00 00       	mov    $0x6,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <exec>:
SYSCALL(exec)
 27d:	b8 07 00 00 00       	mov    $0x7,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <open>:
SYSCALL(open)
 285:	b8 0f 00 00 00       	mov    $0xf,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <mknod>:
SYSCALL(mknod)
 28d:	b8 11 00 00 00       	mov    $0x11,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <unlink>:
SYSCALL(unlink)
 295:	b8 12 00 00 00       	mov    $0x12,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <fstat>:
SYSCALL(fstat)
 29d:	b8 08 00 00 00       	mov    $0x8,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <link>:
SYSCALL(link)
 2a5:	b8 13 00 00 00       	mov    $0x13,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <mkdir>:
SYSCALL(mkdir)
 2ad:	b8 14 00 00 00       	mov    $0x14,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <chdir>:
SYSCALL(chdir)
 2b5:	b8 09 00 00 00       	mov    $0x9,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <dup>:
SYSCALL(dup)
 2bd:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <getpid>:
SYSCALL(getpid)
 2c5:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <sbrk>:
SYSCALL(sbrk)
 2cd:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <sleep>:
SYSCALL(sleep)
 2d5:	b8 0d 00 00 00       	mov    $0xd,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <uptime>:
SYSCALL(uptime)
 2dd:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <settickets>:
SYSCALL(settickets)
 2e5:	b8 16 00 00 00       	mov    $0x16,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <getpinfo>:
SYSCALL(getpinfo)
 2ed:	b8 17 00 00 00       	mov    $0x17,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    
 2f5:	66 90                	xchg   %ax,%ax
 2f7:	90                   	nop

000002f8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	57                   	push   %edi
 2fc:	56                   	push   %esi
 2fd:	53                   	push   %ebx
 2fe:	83 ec 3c             	sub    $0x3c,%esp
 301:	89 45 bc             	mov    %eax,-0x44(%ebp)
 304:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 307:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 309:	8b 5d 08             	mov    0x8(%ebp),%ebx
 30c:	85 db                	test   %ebx,%ebx
 30e:	74 04                	je     314 <printint+0x1c>
 310:	85 d2                	test   %edx,%edx
 312:	78 68                	js     37c <printint+0x84>
  neg = 0;
 314:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 31b:	31 ff                	xor    %edi,%edi
 31d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 320:	89 c8                	mov    %ecx,%eax
 322:	31 d2                	xor    %edx,%edx
 324:	f7 75 c4             	divl   -0x3c(%ebp)
 327:	89 fb                	mov    %edi,%ebx
 329:	8d 7f 01             	lea    0x1(%edi),%edi
 32c:	8a 92 94 06 00 00    	mov    0x694(%edx),%dl
 332:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 336:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 339:	89 c1                	mov    %eax,%ecx
 33b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 33e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 341:	76 dd                	jbe    320 <printint+0x28>
  if(neg)
 343:	8b 4d 08             	mov    0x8(%ebp),%ecx
 346:	85 c9                	test   %ecx,%ecx
 348:	74 09                	je     353 <printint+0x5b>
    buf[i++] = '-';
 34a:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 34f:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 351:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 353:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 357:	8b 7d bc             	mov    -0x44(%ebp),%edi
 35a:	eb 03                	jmp    35f <printint+0x67>
 35c:	8a 13                	mov    (%ebx),%dl
 35e:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 35f:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 362:	50                   	push   %eax
 363:	6a 01                	push   $0x1
 365:	56                   	push   %esi
 366:	57                   	push   %edi
 367:	e8 f9 fe ff ff       	call   265 <write>
  while(--i >= 0)
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	39 de                	cmp    %ebx,%esi
 371:	75 e9                	jne    35c <printint+0x64>
}
 373:	8d 65 f4             	lea    -0xc(%ebp),%esp
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
 37b:	90                   	nop
    x = -xx;
 37c:	f7 d9                	neg    %ecx
 37e:	eb 9b                	jmp    31b <printint+0x23>

00000380 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 389:	8b 75 0c             	mov    0xc(%ebp),%esi
 38c:	8a 1e                	mov    (%esi),%bl
 38e:	84 db                	test   %bl,%bl
 390:	0f 84 a3 00 00 00    	je     439 <printf+0xb9>
 396:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 397:	8d 45 10             	lea    0x10(%ebp),%eax
 39a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 39d:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 39f:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3a2:	eb 29                	jmp    3cd <printf+0x4d>
 3a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3a7:	83 f8 25             	cmp    $0x25,%eax
 3aa:	0f 84 94 00 00 00    	je     444 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 3b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3b3:	50                   	push   %eax
 3b4:	6a 01                	push   $0x1
 3b6:	57                   	push   %edi
 3b7:	ff 75 08             	pushl  0x8(%ebp)
 3ba:	e8 a6 fe ff ff       	call   265 <write>
        putc(fd, c);
 3bf:	83 c4 10             	add    $0x10,%esp
 3c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 3c5:	46                   	inc    %esi
 3c6:	8a 5e ff             	mov    -0x1(%esi),%bl
 3c9:	84 db                	test   %bl,%bl
 3cb:	74 6c                	je     439 <printf+0xb9>
    c = fmt[i] & 0xff;
 3cd:	0f be cb             	movsbl %bl,%ecx
 3d0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3d3:	85 d2                	test   %edx,%edx
 3d5:	74 cd                	je     3a4 <printf+0x24>
      }
    } else if(state == '%'){
 3d7:	83 fa 25             	cmp    $0x25,%edx
 3da:	75 e9                	jne    3c5 <printf+0x45>
      if(c == 'd'){
 3dc:	83 f8 64             	cmp    $0x64,%eax
 3df:	0f 84 97 00 00 00    	je     47c <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3e5:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3eb:	83 f9 70             	cmp    $0x70,%ecx
 3ee:	74 60                	je     450 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3f0:	83 f8 73             	cmp    $0x73,%eax
 3f3:	0f 84 8f 00 00 00    	je     488 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3f9:	83 f8 63             	cmp    $0x63,%eax
 3fc:	0f 84 d6 00 00 00    	je     4d8 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 402:	83 f8 25             	cmp    $0x25,%eax
 405:	0f 84 c1 00 00 00    	je     4cc <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 40b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 40f:	50                   	push   %eax
 410:	6a 01                	push   $0x1
 412:	57                   	push   %edi
 413:	ff 75 08             	pushl  0x8(%ebp)
 416:	e8 4a fe ff ff       	call   265 <write>
        putc(fd, c);
 41b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 41e:	83 c4 0c             	add    $0xc,%esp
 421:	6a 01                	push   $0x1
 423:	57                   	push   %edi
 424:	ff 75 08             	pushl  0x8(%ebp)
 427:	e8 39 fe ff ff       	call   265 <write>
        putc(fd, c);
 42c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 42f:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 431:	46                   	inc    %esi
 432:	8a 5e ff             	mov    -0x1(%esi),%bl
 435:	84 db                	test   %bl,%bl
 437:	75 94                	jne    3cd <printf+0x4d>
    }
  }
}
 439:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43c:	5b                   	pop    %ebx
 43d:	5e                   	pop    %esi
 43e:	5f                   	pop    %edi
 43f:	5d                   	pop    %ebp
 440:	c3                   	ret    
 441:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 444:	ba 25 00 00 00       	mov    $0x25,%edx
 449:	e9 77 ff ff ff       	jmp    3c5 <printf+0x45>
 44e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 450:	83 ec 0c             	sub    $0xc,%esp
 453:	6a 00                	push   $0x0
 455:	b9 10 00 00 00       	mov    $0x10,%ecx
 45a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 45d:	8b 13                	mov    (%ebx),%edx
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	e8 91 fe ff ff       	call   2f8 <printint>
        ap++;
 467:	89 d8                	mov    %ebx,%eax
 469:	83 c0 04             	add    $0x4,%eax
 46c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 46f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 472:	31 d2                	xor    %edx,%edx
        ap++;
 474:	e9 4c ff ff ff       	jmp    3c5 <printf+0x45>
 479:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 47c:	83 ec 0c             	sub    $0xc,%esp
 47f:	6a 01                	push   $0x1
 481:	b9 0a 00 00 00       	mov    $0xa,%ecx
 486:	eb d2                	jmp    45a <printf+0xda>
        s = (char*)*ap;
 488:	8b 45 d0             	mov    -0x30(%ebp),%eax
 48b:	8b 18                	mov    (%eax),%ebx
        ap++;
 48d:	83 c0 04             	add    $0x4,%eax
 490:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 493:	85 db                	test   %ebx,%ebx
 495:	74 65                	je     4fc <printf+0x17c>
        while(*s != 0){
 497:	8a 03                	mov    (%ebx),%al
 499:	84 c0                	test   %al,%al
 49b:	74 70                	je     50d <printf+0x18d>
 49d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4a0:	89 de                	mov    %ebx,%esi
 4a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 4a8:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	50                   	push   %eax
 4ac:	6a 01                	push   $0x1
 4ae:	57                   	push   %edi
 4af:	53                   	push   %ebx
 4b0:	e8 b0 fd ff ff       	call   265 <write>
          s++;
 4b5:	46                   	inc    %esi
        while(*s != 0){
 4b6:	8a 06                	mov    (%esi),%al
 4b8:	83 c4 10             	add    $0x10,%esp
 4bb:	84 c0                	test   %al,%al
 4bd:	75 e9                	jne    4a8 <printf+0x128>
 4bf:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	e9 fc fe ff ff       	jmp    3c5 <printf+0x45>
 4c9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 4cc:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4cf:	52                   	push   %edx
 4d0:	e9 4c ff ff ff       	jmp    421 <printf+0xa1>
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4d8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4db:	8b 03                	mov    (%ebx),%eax
 4dd:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e0:	51                   	push   %ecx
 4e1:	6a 01                	push   $0x1
 4e3:	57                   	push   %edi
 4e4:	ff 75 08             	pushl  0x8(%ebp)
 4e7:	e8 79 fd ff ff       	call   265 <write>
        ap++;
 4ec:	83 c3 04             	add    $0x4,%ebx
 4ef:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4f2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f5:	31 d2                	xor    %edx,%edx
 4f7:	e9 c9 fe ff ff       	jmp    3c5 <printf+0x45>
          s = "(null)";
 4fc:	bb 8c 06 00 00       	mov    $0x68c,%ebx
        while(*s != 0){
 501:	b0 28                	mov    $0x28,%al
 503:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 506:	89 de                	mov    %ebx,%esi
 508:	8b 5d 08             	mov    0x8(%ebp),%ebx
 50b:	eb 9b                	jmp    4a8 <printf+0x128>
      state = 0;
 50d:	31 d2                	xor    %edx,%edx
 50f:	e9 b1 fe ff ff       	jmp    3c5 <printf+0x45>

00000514 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	57                   	push   %edi
 518:	56                   	push   %esi
 519:	53                   	push   %ebx
 51a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 51d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 520:	a1 2c 09 00 00       	mov    0x92c,%eax
 525:	8b 10                	mov    (%eax),%edx
 527:	39 c8                	cmp    %ecx,%eax
 529:	73 11                	jae    53c <free+0x28>
 52b:	90                   	nop
 52c:	39 d1                	cmp    %edx,%ecx
 52e:	72 14                	jb     544 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 530:	39 d0                	cmp    %edx,%eax
 532:	73 10                	jae    544 <free+0x30>
{
 534:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 536:	8b 10                	mov    (%eax),%edx
 538:	39 c8                	cmp    %ecx,%eax
 53a:	72 f0                	jb     52c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 53c:	39 d0                	cmp    %edx,%eax
 53e:	72 f4                	jb     534 <free+0x20>
 540:	39 d1                	cmp    %edx,%ecx
 542:	73 f0                	jae    534 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 544:	8b 73 fc             	mov    -0x4(%ebx),%esi
 547:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 54a:	39 fa                	cmp    %edi,%edx
 54c:	74 1a                	je     568 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 54e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 551:	8b 50 04             	mov    0x4(%eax),%edx
 554:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 557:	39 f1                	cmp    %esi,%ecx
 559:	74 24                	je     57f <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 55b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 55d:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 562:	5b                   	pop    %ebx
 563:	5e                   	pop    %esi
 564:	5f                   	pop    %edi
 565:	5d                   	pop    %ebp
 566:	c3                   	ret    
 567:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 568:	03 72 04             	add    0x4(%edx),%esi
 56b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 56e:	8b 10                	mov    (%eax),%edx
 570:	8b 12                	mov    (%edx),%edx
 572:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 575:	8b 50 04             	mov    0x4(%eax),%edx
 578:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 57b:	39 f1                	cmp    %esi,%ecx
 57d:	75 dc                	jne    55b <free+0x47>
    p->s.size += bp->s.size;
 57f:	03 53 fc             	add    -0x4(%ebx),%edx
 582:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 585:	8b 53 f8             	mov    -0x8(%ebx),%edx
 588:	89 10                	mov    %edx,(%eax)
  freep = p;
 58a:	a3 2c 09 00 00       	mov    %eax,0x92c
}
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    

00000594 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	8d 70 07             	lea    0x7(%eax),%esi
 5a3:	c1 ee 03             	shr    $0x3,%esi
 5a6:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5a7:	8b 3d 2c 09 00 00    	mov    0x92c,%edi
 5ad:	85 ff                	test   %edi,%edi
 5af:	0f 84 a3 00 00 00    	je     658 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b5:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 5b7:	8b 48 04             	mov    0x4(%eax),%ecx
 5ba:	39 f1                	cmp    %esi,%ecx
 5bc:	73 67                	jae    625 <malloc+0x91>
 5be:	89 f3                	mov    %esi,%ebx
 5c0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 5c6:	0f 82 80 00 00 00    	jb     64c <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 5cc:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 5d3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 5d6:	eb 11                	jmp    5e9 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d8:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5da:	8b 4a 04             	mov    0x4(%edx),%ecx
 5dd:	39 f1                	cmp    %esi,%ecx
 5df:	73 4b                	jae    62c <malloc+0x98>
 5e1:	8b 3d 2c 09 00 00    	mov    0x92c,%edi
 5e7:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5e9:	39 c7                	cmp    %eax,%edi
 5eb:	75 eb                	jne    5d8 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	ff 75 e4             	pushl  -0x1c(%ebp)
 5f3:	e8 d5 fc ff ff       	call   2cd <sbrk>
  if(p == (char*)-1)
 5f8:	83 c4 10             	add    $0x10,%esp
 5fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 5fe:	74 1b                	je     61b <malloc+0x87>
  hp->s.size = nu;
 600:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 603:	83 ec 0c             	sub    $0xc,%esp
 606:	83 c0 08             	add    $0x8,%eax
 609:	50                   	push   %eax
 60a:	e8 05 ff ff ff       	call   514 <free>
  return freep;
 60f:	a1 2c 09 00 00       	mov    0x92c,%eax
      if((p = morecore(nunits)) == 0)
 614:	83 c4 10             	add    $0x10,%esp
 617:	85 c0                	test   %eax,%eax
 619:	75 bd                	jne    5d8 <malloc+0x44>
        return 0;
 61b:	31 c0                	xor    %eax,%eax
  }
}
 61d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 620:	5b                   	pop    %ebx
 621:	5e                   	pop    %esi
 622:	5f                   	pop    %edi
 623:	5d                   	pop    %ebp
 624:	c3                   	ret    
    if(p->s.size >= nunits){
 625:	89 c2                	mov    %eax,%edx
 627:	89 f8                	mov    %edi,%eax
 629:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 62c:	39 ce                	cmp    %ecx,%esi
 62e:	74 54                	je     684 <malloc+0xf0>
        p->s.size -= nunits;
 630:	29 f1                	sub    %esi,%ecx
 632:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 635:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 638:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 63b:	a3 2c 09 00 00       	mov    %eax,0x92c
      return (void*)(p + 1);
 640:	8d 42 08             	lea    0x8(%edx),%eax
}
 643:	8d 65 f4             	lea    -0xc(%ebp),%esp
 646:	5b                   	pop    %ebx
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	90                   	nop
 64c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 651:	e9 76 ff ff ff       	jmp    5cc <malloc+0x38>
 656:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 658:	c7 05 2c 09 00 00 30 	movl   $0x930,0x92c
 65f:	09 00 00 
 662:	c7 05 30 09 00 00 30 	movl   $0x930,0x930
 669:	09 00 00 
    base.s.size = 0;
 66c:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 673:	00 00 00 
 676:	bf 30 09 00 00       	mov    $0x930,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67b:	89 f8                	mov    %edi,%eax
 67d:	e9 3c ff ff ff       	jmp    5be <malloc+0x2a>
 682:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 684:	8b 0a                	mov    (%edx),%ecx
 686:	89 08                	mov    %ecx,(%eax)
 688:	eb b1                	jmp    63b <malloc+0xa7>
