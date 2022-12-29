
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  for(i = 1; i < argc; i++)
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 47                	jle    64 <main+0x64>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 04             	add    $0x4,%ebx
  26:	8b 43 fc             	mov    -0x4(%ebx),%eax
  29:	39 f3                	cmp    %esi,%ebx
  2b:	74 22                	je     4f <main+0x4f>
  2d:	8d 76 00             	lea    0x0(%esi),%esi
  30:	68 64 06 00 00       	push   $0x664
  35:	50                   	push   %eax
  36:	68 66 06 00 00       	push   $0x666
  3b:	6a 01                	push   $0x1
  3d:	e8 16 03 00 00       	call   358 <printf>
  42:	83 c4 10             	add    $0x10,%esp
  45:	83 c3 04             	add    $0x4,%ebx
  48:	8b 43 fc             	mov    -0x4(%ebx),%eax
  4b:	39 f3                	cmp    %esi,%ebx
  4d:	75 e1                	jne    30 <main+0x30>
  4f:	68 6b 06 00 00       	push   $0x66b
  54:	50                   	push   %eax
  55:	68 66 06 00 00       	push   $0x666
  5a:	6a 01                	push   $0x1
  5c:	e8 f7 02 00 00       	call   358 <printf>
  61:	83 c4 10             	add    $0x10,%esp
  exit();
  64:	e8 b4 01 00 00       	call   21d <exit>
  69:	66 90                	xchg   %ax,%ax
  6b:	90                   	nop

0000006c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	53                   	push   %ebx
  70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	31 c0                	xor    %eax,%eax
  78:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  7b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  7e:	40                   	inc    %eax
  7f:	84 d2                	test   %dl,%dl
  81:	75 f5                	jne    78 <strcpy+0xc>
    ;
  return os;
}
  83:	89 c8                	mov    %ecx,%eax
  85:	5b                   	pop    %ebx
  86:	5d                   	pop    %ebp
  87:	c3                   	ret    

00000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	53                   	push   %ebx
  8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  92:	0f b6 03             	movzbl (%ebx),%eax
  95:	0f b6 0a             	movzbl (%edx),%ecx
  98:	84 c0                	test   %al,%al
  9a:	75 10                	jne    ac <strcmp+0x24>
  9c:	eb 1a                	jmp    b8 <strcmp+0x30>
  9e:	66 90                	xchg   %ax,%ax
    p++, q++;
  a0:	43                   	inc    %ebx
  a1:	42                   	inc    %edx
  while(*p && *p == *q)
  a2:	0f b6 03             	movzbl (%ebx),%eax
  a5:	0f b6 0a             	movzbl (%edx),%ecx
  a8:	84 c0                	test   %al,%al
  aa:	74 0c                	je     b8 <strcmp+0x30>
  ac:	38 c8                	cmp    %cl,%al
  ae:	74 f0                	je     a0 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b0:	29 c8                	sub    %ecx,%eax
}
  b2:	5b                   	pop    %ebx
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    
  b5:	8d 76 00             	lea    0x0(%esi),%esi
  b8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  ba:	29 c8                	sub    %ecx,%eax
}
  bc:	5b                   	pop    %ebx
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
  bf:	90                   	nop

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	40                   	inc    %eax
  d1:	89 c1                	mov    %eax,%ecx
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	75 f7                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  d9:	89 c8                	mov    %ecx,%eax
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	89 c8                	mov    %ecx,%eax
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    
  e6:	66 90                	xchg   %ax,%ax

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  eb:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	fc                   	cld    
  f6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	5f                   	pop    %edi
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    
  fe:	66 90                	xchg   %ax,%ax

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 109:	8a 10                	mov    (%eax),%dl
 10b:	84 d2                	test   %dl,%dl
 10d:	75 0c                	jne    11b <strchr+0x1b>
 10f:	eb 13                	jmp    124 <strchr+0x24>
 111:	8d 76 00             	lea    0x0(%esi),%esi
 114:	40                   	inc    %eax
 115:	8a 10                	mov    (%eax),%dl
 117:	84 d2                	test   %dl,%dl
 119:	74 09                	je     124 <strchr+0x24>
    if(*s == c)
 11b:	38 d1                	cmp    %dl,%cl
 11d:	75 f5                	jne    114 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 124:	31 c0                	xor    %eax,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	57                   	push   %edi
 12c:	56                   	push   %esi
 12d:	53                   	push   %ebx
 12e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 131:	8b 75 08             	mov    0x8(%ebp),%esi
 134:	bb 01 00 00 00       	mov    $0x1,%ebx
 139:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 13b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 13e:	eb 20                	jmp    160 <gets+0x38>
    cc = read(0, &c, 1);
 140:	50                   	push   %eax
 141:	6a 01                	push   $0x1
 143:	57                   	push   %edi
 144:	6a 00                	push   $0x0
 146:	e8 ea 00 00 00       	call   235 <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 16                	jle    168 <gets+0x40>
      break;
    buf[i++] = c;
 152:	8a 45 e7             	mov    -0x19(%ebp),%al
 155:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 157:	46                   	inc    %esi
 158:	3c 0a                	cmp    $0xa,%al
 15a:	74 0c                	je     168 <gets+0x40>
 15c:	3c 0d                	cmp    $0xd,%al
 15e:	74 08                	je     168 <gets+0x40>
  for(i=0; i+1 < max; ){
 160:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 163:	39 45 0c             	cmp    %eax,0xc(%ebp)
 166:	7f d8                	jg     140 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 168:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 171:	5b                   	pop    %ebx
 172:	5e                   	pop    %esi
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    
 176:	66 90                	xchg   %ax,%ax

00000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	56                   	push   %esi
 17c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17d:	83 ec 08             	sub    $0x8,%esp
 180:	6a 00                	push   $0x0
 182:	ff 75 08             	pushl  0x8(%ebp)
 185:	e8 d3 00 00 00       	call   25d <open>
  if(fd < 0)
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 27                	js     1b8 <stat+0x40>
 191:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 193:	83 ec 08             	sub    $0x8,%esp
 196:	ff 75 0c             	pushl  0xc(%ebp)
 199:	50                   	push   %eax
 19a:	e8 d6 00 00 00       	call   275 <fstat>
 19f:	89 c6                	mov    %eax,%esi
  close(fd);
 1a1:	89 1c 24             	mov    %ebx,(%esp)
 1a4:	e8 9c 00 00 00       	call   245 <close>
  return r;
 1a9:	83 c4 10             	add    $0x10,%esp
}
 1ac:	89 f0                	mov    %esi,%eax
 1ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b1:	5b                   	pop    %ebx
 1b2:	5e                   	pop    %esi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bd:	eb ed                	jmp    1ac <stat+0x34>
 1bf:	90                   	nop

000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f be 01             	movsbl (%ecx),%eax
 1ca:	8d 50 d0             	lea    -0x30(%eax),%edx
 1cd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d5:	77 16                	ja     1ed <atoi+0x2d>
 1d7:	90                   	nop
    n = n*10 + *s++ - '0';
 1d8:	41                   	inc    %ecx
 1d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1dc:	01 d2                	add    %edx,%edx
 1de:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1e2:	0f be 01             	movsbl (%ecx),%eax
 1e5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1e8:	80 fb 09             	cmp    $0x9,%bl
 1eb:	76 eb                	jbe    1d8 <atoi+0x18>
  return n;
}
 1ed:	89 d0                	mov    %edx,%eax
 1ef:	5b                   	pop    %ebx
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    
 1f2:	66 90                	xchg   %ax,%ax

000001f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	56                   	push   %esi
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 202:	85 d2                	test   %edx,%edx
 204:	7e 0b                	jle    211 <memmove+0x1d>
 206:	01 c2                	add    %eax,%edx
  dst = vdst;
 208:	89 c7                	mov    %eax,%edi
 20a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 20c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 20d:	39 fa                	cmp    %edi,%edx
 20f:	75 fb                	jne    20c <memmove+0x18>
  return vdst;
}
 211:	5e                   	pop    %esi
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    

00000215 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 215:	b8 01 00 00 00       	mov    $0x1,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <exit>:
SYSCALL(exit)
 21d:	b8 02 00 00 00       	mov    $0x2,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <wait>:
SYSCALL(wait)
 225:	b8 03 00 00 00       	mov    $0x3,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <pipe>:
SYSCALL(pipe)
 22d:	b8 04 00 00 00       	mov    $0x4,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <read>:
SYSCALL(read)
 235:	b8 05 00 00 00       	mov    $0x5,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <write>:
SYSCALL(write)
 23d:	b8 10 00 00 00       	mov    $0x10,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <close>:
SYSCALL(close)
 245:	b8 15 00 00 00       	mov    $0x15,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <kill>:
SYSCALL(kill)
 24d:	b8 06 00 00 00       	mov    $0x6,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <exec>:
SYSCALL(exec)
 255:	b8 07 00 00 00       	mov    $0x7,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <open>:
SYSCALL(open)
 25d:	b8 0f 00 00 00       	mov    $0xf,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <mknod>:
SYSCALL(mknod)
 265:	b8 11 00 00 00       	mov    $0x11,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <unlink>:
SYSCALL(unlink)
 26d:	b8 12 00 00 00       	mov    $0x12,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <fstat>:
SYSCALL(fstat)
 275:	b8 08 00 00 00       	mov    $0x8,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <link>:
SYSCALL(link)
 27d:	b8 13 00 00 00       	mov    $0x13,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <mkdir>:
SYSCALL(mkdir)
 285:	b8 14 00 00 00       	mov    $0x14,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <chdir>:
SYSCALL(chdir)
 28d:	b8 09 00 00 00       	mov    $0x9,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <dup>:
SYSCALL(dup)
 295:	b8 0a 00 00 00       	mov    $0xa,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <getpid>:
SYSCALL(getpid)
 29d:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <sbrk>:
SYSCALL(sbrk)
 2a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <sleep>:
SYSCALL(sleep)
 2ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <uptime>:
SYSCALL(uptime)
 2b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <settickets>:
SYSCALL(settickets)
 2bd:	b8 16 00 00 00       	mov    $0x16,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <getpinfo>:
SYSCALL(getpinfo)
 2c5:	b8 17 00 00 00       	mov    $0x17,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    
 2cd:	66 90                	xchg   %ax,%ax
 2cf:	90                   	nop

000002d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	53                   	push   %ebx
 2d6:	83 ec 3c             	sub    $0x3c,%esp
 2d9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2dc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2df:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2e4:	85 db                	test   %ebx,%ebx
 2e6:	74 04                	je     2ec <printint+0x1c>
 2e8:	85 d2                	test   %edx,%edx
 2ea:	78 68                	js     354 <printint+0x84>
  neg = 0;
 2ec:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f3:	31 ff                	xor    %edi,%edi
 2f5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	31 d2                	xor    %edx,%edx
 2fc:	f7 75 c4             	divl   -0x3c(%ebp)
 2ff:	89 fb                	mov    %edi,%ebx
 301:	8d 7f 01             	lea    0x1(%edi),%edi
 304:	8a 92 74 06 00 00    	mov    0x674(%edx),%dl
 30a:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 30e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 311:	89 c1                	mov    %eax,%ecx
 313:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 316:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 319:	76 dd                	jbe    2f8 <printint+0x28>
  if(neg)
 31b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31e:	85 c9                	test   %ecx,%ecx
 320:	74 09                	je     32b <printint+0x5b>
    buf[i++] = '-';
 322:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 327:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 329:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 32b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 32f:	8b 7d bc             	mov    -0x44(%ebp),%edi
 332:	eb 03                	jmp    337 <printint+0x67>
 334:	8a 13                	mov    (%ebx),%dl
 336:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 337:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 33a:	50                   	push   %eax
 33b:	6a 01                	push   $0x1
 33d:	56                   	push   %esi
 33e:	57                   	push   %edi
 33f:	e8 f9 fe ff ff       	call   23d <write>
  while(--i >= 0)
 344:	83 c4 10             	add    $0x10,%esp
 347:	39 de                	cmp    %ebx,%esi
 349:	75 e9                	jne    334 <printint+0x64>
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	90                   	nop
    x = -xx;
 354:	f7 d9                	neg    %ecx
 356:	eb 9b                	jmp    2f3 <printint+0x23>

00000358 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 361:	8b 75 0c             	mov    0xc(%ebp),%esi
 364:	8a 1e                	mov    (%esi),%bl
 366:	84 db                	test   %bl,%bl
 368:	0f 84 a3 00 00 00    	je     411 <printf+0xb9>
 36e:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 36f:	8d 45 10             	lea    0x10(%ebp),%eax
 372:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 375:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 377:	8d 7d e7             	lea    -0x19(%ebp),%edi
 37a:	eb 29                	jmp    3a5 <printf+0x4d>
 37c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 37f:	83 f8 25             	cmp    $0x25,%eax
 382:	0f 84 94 00 00 00    	je     41c <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 388:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 38b:	50                   	push   %eax
 38c:	6a 01                	push   $0x1
 38e:	57                   	push   %edi
 38f:	ff 75 08             	pushl  0x8(%ebp)
 392:	e8 a6 fe ff ff       	call   23d <write>
        putc(fd, c);
 397:	83 c4 10             	add    $0x10,%esp
 39a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 39d:	46                   	inc    %esi
 39e:	8a 5e ff             	mov    -0x1(%esi),%bl
 3a1:	84 db                	test   %bl,%bl
 3a3:	74 6c                	je     411 <printf+0xb9>
    c = fmt[i] & 0xff;
 3a5:	0f be cb             	movsbl %bl,%ecx
 3a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3ab:	85 d2                	test   %edx,%edx
 3ad:	74 cd                	je     37c <printf+0x24>
      }
    } else if(state == '%'){
 3af:	83 fa 25             	cmp    $0x25,%edx
 3b2:	75 e9                	jne    39d <printf+0x45>
      if(c == 'd'){
 3b4:	83 f8 64             	cmp    $0x64,%eax
 3b7:	0f 84 97 00 00 00    	je     454 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3bd:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3c3:	83 f9 70             	cmp    $0x70,%ecx
 3c6:	74 60                	je     428 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3c8:	83 f8 73             	cmp    $0x73,%eax
 3cb:	0f 84 8f 00 00 00    	je     460 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3d1:	83 f8 63             	cmp    $0x63,%eax
 3d4:	0f 84 d6 00 00 00    	je     4b0 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3da:	83 f8 25             	cmp    $0x25,%eax
 3dd:	0f 84 c1 00 00 00    	je     4a4 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3e3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3e7:	50                   	push   %eax
 3e8:	6a 01                	push   $0x1
 3ea:	57                   	push   %edi
 3eb:	ff 75 08             	pushl  0x8(%ebp)
 3ee:	e8 4a fe ff ff       	call   23d <write>
        putc(fd, c);
 3f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3f6:	83 c4 0c             	add    $0xc,%esp
 3f9:	6a 01                	push   $0x1
 3fb:	57                   	push   %edi
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 39 fe ff ff       	call   23d <write>
        putc(fd, c);
 404:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 407:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 409:	46                   	inc    %esi
 40a:	8a 5e ff             	mov    -0x1(%esi),%bl
 40d:	84 db                	test   %bl,%bl
 40f:	75 94                	jne    3a5 <printf+0x4d>
    }
  }
}
 411:	8d 65 f4             	lea    -0xc(%ebp),%esp
 414:	5b                   	pop    %ebx
 415:	5e                   	pop    %esi
 416:	5f                   	pop    %edi
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 41c:	ba 25 00 00 00       	mov    $0x25,%edx
 421:	e9 77 ff ff ff       	jmp    39d <printf+0x45>
 426:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 428:	83 ec 0c             	sub    $0xc,%esp
 42b:	6a 00                	push   $0x0
 42d:	b9 10 00 00 00       	mov    $0x10,%ecx
 432:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 435:	8b 13                	mov    (%ebx),%edx
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	e8 91 fe ff ff       	call   2d0 <printint>
        ap++;
 43f:	89 d8                	mov    %ebx,%eax
 441:	83 c0 04             	add    $0x4,%eax
 444:	89 45 d0             	mov    %eax,-0x30(%ebp)
 447:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44a:	31 d2                	xor    %edx,%edx
        ap++;
 44c:	e9 4c ff ff ff       	jmp    39d <printf+0x45>
 451:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 454:	83 ec 0c             	sub    $0xc,%esp
 457:	6a 01                	push   $0x1
 459:	b9 0a 00 00 00       	mov    $0xa,%ecx
 45e:	eb d2                	jmp    432 <printf+0xda>
        s = (char*)*ap;
 460:	8b 45 d0             	mov    -0x30(%ebp),%eax
 463:	8b 18                	mov    (%eax),%ebx
        ap++;
 465:	83 c0 04             	add    $0x4,%eax
 468:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 46b:	85 db                	test   %ebx,%ebx
 46d:	74 65                	je     4d4 <printf+0x17c>
        while(*s != 0){
 46f:	8a 03                	mov    (%ebx),%al
 471:	84 c0                	test   %al,%al
 473:	74 70                	je     4e5 <printf+0x18d>
 475:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 478:	89 de                	mov    %ebx,%esi
 47a:	8b 5d 08             	mov    0x8(%ebp),%ebx
 47d:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 480:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 483:	50                   	push   %eax
 484:	6a 01                	push   $0x1
 486:	57                   	push   %edi
 487:	53                   	push   %ebx
 488:	e8 b0 fd ff ff       	call   23d <write>
          s++;
 48d:	46                   	inc    %esi
        while(*s != 0){
 48e:	8a 06                	mov    (%esi),%al
 490:	83 c4 10             	add    $0x10,%esp
 493:	84 c0                	test   %al,%al
 495:	75 e9                	jne    480 <printf+0x128>
 497:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 49a:	31 d2                	xor    %edx,%edx
 49c:	e9 fc fe ff ff       	jmp    39d <printf+0x45>
 4a1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 4a4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4a7:	52                   	push   %edx
 4a8:	e9 4c ff ff ff       	jmp    3f9 <printf+0xa1>
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4b3:	8b 03                	mov    (%ebx),%eax
 4b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4b8:	51                   	push   %ecx
 4b9:	6a 01                	push   $0x1
 4bb:	57                   	push   %edi
 4bc:	ff 75 08             	pushl  0x8(%ebp)
 4bf:	e8 79 fd ff ff       	call   23d <write>
        ap++;
 4c4:	83 c3 04             	add    $0x4,%ebx
 4c7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cd:	31 d2                	xor    %edx,%edx
 4cf:	e9 c9 fe ff ff       	jmp    39d <printf+0x45>
          s = "(null)";
 4d4:	bb 6d 06 00 00       	mov    $0x66d,%ebx
        while(*s != 0){
 4d9:	b0 28                	mov    $0x28,%al
 4db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4de:	89 de                	mov    %ebx,%esi
 4e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4e3:	eb 9b                	jmp    480 <printf+0x128>
      state = 0;
 4e5:	31 d2                	xor    %edx,%edx
 4e7:	e9 b1 fe ff ff       	jmp    39d <printf+0x45>

000004ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	57                   	push   %edi
 4f0:	56                   	push   %esi
 4f1:	53                   	push   %ebx
 4f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4f5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f8:	a1 14 09 00 00       	mov    0x914,%eax
 4fd:	8b 10                	mov    (%eax),%edx
 4ff:	39 c8                	cmp    %ecx,%eax
 501:	73 11                	jae    514 <free+0x28>
 503:	90                   	nop
 504:	39 d1                	cmp    %edx,%ecx
 506:	72 14                	jb     51c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 508:	39 d0                	cmp    %edx,%eax
 50a:	73 10                	jae    51c <free+0x30>
{
 50c:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 50e:	8b 10                	mov    (%eax),%edx
 510:	39 c8                	cmp    %ecx,%eax
 512:	72 f0                	jb     504 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 514:	39 d0                	cmp    %edx,%eax
 516:	72 f4                	jb     50c <free+0x20>
 518:	39 d1                	cmp    %edx,%ecx
 51a:	73 f0                	jae    50c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 51c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 51f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 522:	39 fa                	cmp    %edi,%edx
 524:	74 1a                	je     540 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 526:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 529:	8b 50 04             	mov    0x4(%eax),%edx
 52c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 52f:	39 f1                	cmp    %esi,%ecx
 531:	74 24                	je     557 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 533:	89 08                	mov    %ecx,(%eax)
  freep = p;
 535:	a3 14 09 00 00       	mov    %eax,0x914
}
 53a:	5b                   	pop    %ebx
 53b:	5e                   	pop    %esi
 53c:	5f                   	pop    %edi
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    
 53f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 540:	03 72 04             	add    0x4(%edx),%esi
 543:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 546:	8b 10                	mov    (%eax),%edx
 548:	8b 12                	mov    (%edx),%edx
 54a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 54d:	8b 50 04             	mov    0x4(%eax),%edx
 550:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 553:	39 f1                	cmp    %esi,%ecx
 555:	75 dc                	jne    533 <free+0x47>
    p->s.size += bp->s.size;
 557:	03 53 fc             	add    -0x4(%ebx),%edx
 55a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 55d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 560:	89 10                	mov    %edx,(%eax)
  freep = p;
 562:	a3 14 09 00 00       	mov    %eax,0x914
}
 567:	5b                   	pop    %ebx
 568:	5e                   	pop    %esi
 569:	5f                   	pop    %edi
 56a:	5d                   	pop    %ebp
 56b:	c3                   	ret    

0000056c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	57                   	push   %edi
 570:	56                   	push   %esi
 571:	53                   	push   %ebx
 572:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	8d 70 07             	lea    0x7(%eax),%esi
 57b:	c1 ee 03             	shr    $0x3,%esi
 57e:	46                   	inc    %esi
  if((prevp = freep) == 0){
 57f:	8b 3d 14 09 00 00    	mov    0x914,%edi
 585:	85 ff                	test   %edi,%edi
 587:	0f 84 a3 00 00 00    	je     630 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 58d:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 58f:	8b 48 04             	mov    0x4(%eax),%ecx
 592:	39 f1                	cmp    %esi,%ecx
 594:	73 67                	jae    5fd <malloc+0x91>
 596:	89 f3                	mov    %esi,%ebx
 598:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 59e:	0f 82 80 00 00 00    	jb     624 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 5a4:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 5ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 5ae:	eb 11                	jmp    5c1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 5b5:	39 f1                	cmp    %esi,%ecx
 5b7:	73 4b                	jae    604 <malloc+0x98>
 5b9:	8b 3d 14 09 00 00    	mov    0x914,%edi
 5bf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5c1:	39 c7                	cmp    %eax,%edi
 5c3:	75 eb                	jne    5b0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5c5:	83 ec 0c             	sub    $0xc,%esp
 5c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 5cb:	e8 d5 fc ff ff       	call   2a5 <sbrk>
  if(p == (char*)-1)
 5d0:	83 c4 10             	add    $0x10,%esp
 5d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5d6:	74 1b                	je     5f3 <malloc+0x87>
  hp->s.size = nu;
 5d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5db:	83 ec 0c             	sub    $0xc,%esp
 5de:	83 c0 08             	add    $0x8,%eax
 5e1:	50                   	push   %eax
 5e2:	e8 05 ff ff ff       	call   4ec <free>
  return freep;
 5e7:	a1 14 09 00 00       	mov    0x914,%eax
      if((p = morecore(nunits)) == 0)
 5ec:	83 c4 10             	add    $0x10,%esp
 5ef:	85 c0                	test   %eax,%eax
 5f1:	75 bd                	jne    5b0 <malloc+0x44>
        return 0;
 5f3:	31 c0                	xor    %eax,%eax
  }
}
 5f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f8:	5b                   	pop    %ebx
 5f9:	5e                   	pop    %esi
 5fa:	5f                   	pop    %edi
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret    
    if(p->s.size >= nunits){
 5fd:	89 c2                	mov    %eax,%edx
 5ff:	89 f8                	mov    %edi,%eax
 601:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 604:	39 ce                	cmp    %ecx,%esi
 606:	74 54                	je     65c <malloc+0xf0>
        p->s.size -= nunits;
 608:	29 f1                	sub    %esi,%ecx
 60a:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 60d:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 610:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 613:	a3 14 09 00 00       	mov    %eax,0x914
      return (void*)(p + 1);
 618:	8d 42 08             	lea    0x8(%edx),%eax
}
 61b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61e:	5b                   	pop    %ebx
 61f:	5e                   	pop    %esi
 620:	5f                   	pop    %edi
 621:	5d                   	pop    %ebp
 622:	c3                   	ret    
 623:	90                   	nop
 624:	bb 00 10 00 00       	mov    $0x1000,%ebx
 629:	e9 76 ff ff ff       	jmp    5a4 <malloc+0x38>
 62e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 630:	c7 05 14 09 00 00 18 	movl   $0x918,0x914
 637:	09 00 00 
 63a:	c7 05 18 09 00 00 18 	movl   $0x918,0x918
 641:	09 00 00 
    base.s.size = 0;
 644:	c7 05 1c 09 00 00 00 	movl   $0x0,0x91c
 64b:	00 00 00 
 64e:	bf 18 09 00 00       	mov    $0x918,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 653:	89 f8                	mov    %edi,%eax
 655:	e9 3c ff ff ff       	jmp    596 <malloc+0x2a>
 65a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 65c:	8b 0a                	mov    (%edx),%ecx
 65e:	89 08                	mov    %ecx,(%eax)
 660:	eb b1                	jmp    613 <malloc+0xa7>
