
_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 13                	je     2a <main+0x2a>
    printf(2, "Usage: ln old new\n");
  17:	52                   	push   %edx
  18:	52                   	push   %edx
  19:	68 54 06 00 00       	push   $0x654
  1e:	6a 02                	push   $0x2
  20:	e8 23 03 00 00       	call   348 <printf>
    exit();
  25:	e8 e3 01 00 00       	call   20d <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2a:	50                   	push   %eax
  2b:	50                   	push   %eax
  2c:	ff 73 08             	pushl  0x8(%ebx)
  2f:	ff 73 04             	pushl  0x4(%ebx)
  32:	e8 36 02 00 00       	call   26d <link>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 05                	js     43 <main+0x43>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3e:	e8 ca 01 00 00       	call   20d <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  43:	ff 73 08             	pushl  0x8(%ebx)
  46:	ff 73 04             	pushl  0x4(%ebx)
  49:	68 67 06 00 00       	push   $0x667
  4e:	6a 02                	push   $0x2
  50:	e8 f3 02 00 00       	call   348 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e4                	jmp    3e <main+0x3e>
  5a:	66 90                	xchg   %ax,%ax

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	31 c0                	xor    %eax,%eax
  68:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  6b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6e:	40                   	inc    %eax
  6f:	84 d2                	test   %dl,%dl
  71:	75 f5                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  73:	89 c8                	mov    %ecx,%eax
  75:	5b                   	pop    %ebx
  76:	5d                   	pop    %ebp
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  82:	0f b6 03             	movzbl (%ebx),%eax
  85:	0f b6 0a             	movzbl (%edx),%ecx
  88:	84 c0                	test   %al,%al
  8a:	75 10                	jne    9c <strcmp+0x24>
  8c:	eb 1a                	jmp    a8 <strcmp+0x30>
  8e:	66 90                	xchg   %ax,%ax
    p++, q++;
  90:	43                   	inc    %ebx
  91:	42                   	inc    %edx
  while(*p && *p == *q)
  92:	0f b6 03             	movzbl (%ebx),%eax
  95:	0f b6 0a             	movzbl (%edx),%ecx
  98:	84 c0                	test   %al,%al
  9a:	74 0c                	je     a8 <strcmp+0x30>
  9c:	38 c8                	cmp    %cl,%al
  9e:	74 f0                	je     90 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  a0:	29 c8                	sub    %ecx,%eax
}
  a2:	5b                   	pop    %ebx
  a3:	5d                   	pop    %ebp
  a4:	c3                   	ret    
  a5:	8d 76 00             	lea    0x0(%esi),%esi
  a8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  aa:	29 c8                	sub    %ecx,%eax
}
  ac:	5b                   	pop    %ebx
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    
  af:	90                   	nop

000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b6:	80 3a 00             	cmpb   $0x0,(%edx)
  b9:	74 15                	je     d0 <strlen+0x20>
  bb:	31 c0                	xor    %eax,%eax
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	40                   	inc    %eax
  c1:	89 c1                	mov    %eax,%ecx
  c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c7:	75 f7                	jne    c0 <strlen+0x10>
    ;
  return n;
}
  c9:	89 c8                	mov    %ecx,%eax
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  d0:	31 c9                	xor    %ecx,%ecx
}
  d2:	89 c8                	mov    %ecx,%eax
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    
  d6:	66 90                	xchg   %ax,%ax

000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	fc                   	cld    
  e6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	5f                   	pop    %edi
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f9:	8a 10                	mov    (%eax),%dl
  fb:	84 d2                	test   %dl,%dl
  fd:	75 0c                	jne    10b <strchr+0x1b>
  ff:	eb 13                	jmp    114 <strchr+0x24>
 101:	8d 76 00             	lea    0x0(%esi),%esi
 104:	40                   	inc    %eax
 105:	8a 10                	mov    (%eax),%dl
 107:	84 d2                	test   %dl,%dl
 109:	74 09                	je     114 <strchr+0x24>
    if(*s == c)
 10b:	38 d1                	cmp    %dl,%cl
 10d:	75 f5                	jne    104 <strchr+0x14>
      return (char*)s;
  return 0;
}
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
 111:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 114:	31 c0                	xor    %eax,%eax
}
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    

00000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	56                   	push   %esi
 11d:	53                   	push   %ebx
 11e:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 121:	8b 75 08             	mov    0x8(%ebp),%esi
 124:	bb 01 00 00 00       	mov    $0x1,%ebx
 129:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 12b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12e:	eb 20                	jmp    150 <gets+0x38>
    cc = read(0, &c, 1);
 130:	50                   	push   %eax
 131:	6a 01                	push   $0x1
 133:	57                   	push   %edi
 134:	6a 00                	push   $0x0
 136:	e8 ea 00 00 00       	call   225 <read>
    if(cc < 1)
 13b:	83 c4 10             	add    $0x10,%esp
 13e:	85 c0                	test   %eax,%eax
 140:	7e 16                	jle    158 <gets+0x40>
      break;
    buf[i++] = c;
 142:	8a 45 e7             	mov    -0x19(%ebp),%al
 145:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 147:	46                   	inc    %esi
 148:	3c 0a                	cmp    $0xa,%al
 14a:	74 0c                	je     158 <gets+0x40>
 14c:	3c 0d                	cmp    $0xd,%al
 14e:	74 08                	je     158 <gets+0x40>
  for(i=0; i+1 < max; ){
 150:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 153:	39 45 0c             	cmp    %eax,0xc(%ebp)
 156:	7f d8                	jg     130 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 158:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	66 90                	xchg   %ax,%ax

00000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	56                   	push   %esi
 16c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16d:	83 ec 08             	sub    $0x8,%esp
 170:	6a 00                	push   $0x0
 172:	ff 75 08             	pushl  0x8(%ebp)
 175:	e8 d3 00 00 00       	call   24d <open>
  if(fd < 0)
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	85 c0                	test   %eax,%eax
 17f:	78 27                	js     1a8 <stat+0x40>
 181:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 183:	83 ec 08             	sub    $0x8,%esp
 186:	ff 75 0c             	pushl  0xc(%ebp)
 189:	50                   	push   %eax
 18a:	e8 d6 00 00 00       	call   265 <fstat>
 18f:	89 c6                	mov    %eax,%esi
  close(fd);
 191:	89 1c 24             	mov    %ebx,(%esp)
 194:	e8 9c 00 00 00       	call   235 <close>
  return r;
 199:	83 c4 10             	add    $0x10,%esp
}
 19c:	89 f0                	mov    %esi,%eax
 19e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a1:	5b                   	pop    %ebx
 1a2:	5e                   	pop    %esi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1ad:	eb ed                	jmp    19c <stat+0x34>
 1af:	90                   	nop

000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b7:	0f be 01             	movsbl (%ecx),%eax
 1ba:	8d 50 d0             	lea    -0x30(%eax),%edx
 1bd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1c0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c5:	77 16                	ja     1dd <atoi+0x2d>
 1c7:	90                   	nop
    n = n*10 + *s++ - '0';
 1c8:	41                   	inc    %ecx
 1c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1cc:	01 d2                	add    %edx,%edx
 1ce:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1d2:	0f be 01             	movsbl (%ecx),%eax
 1d5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d8:	80 fb 09             	cmp    $0x9,%bl
 1db:	76 eb                	jbe    1c8 <atoi+0x18>
  return n;
}
 1dd:	89 d0                	mov    %edx,%eax
 1df:	5b                   	pop    %ebx
 1e0:	5d                   	pop    %ebp
 1e1:	c3                   	ret    
 1e2:	66 90                	xchg   %ax,%ax

000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	57                   	push   %edi
 1e8:	56                   	push   %esi
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	85 d2                	test   %edx,%edx
 1f4:	7e 0b                	jle    201 <memmove+0x1d>
 1f6:	01 c2                	add    %eax,%edx
  dst = vdst;
 1f8:	89 c7                	mov    %eax,%edi
 1fa:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1fc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1fd:	39 fa                	cmp    %edi,%edx
 1ff:	75 fb                	jne    1fc <memmove+0x18>
  return vdst;
}
 201:	5e                   	pop    %esi
 202:	5f                   	pop    %edi
 203:	5d                   	pop    %ebp
 204:	c3                   	ret    

00000205 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 205:	b8 01 00 00 00       	mov    $0x1,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <exit>:
SYSCALL(exit)
 20d:	b8 02 00 00 00       	mov    $0x2,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <wait>:
SYSCALL(wait)
 215:	b8 03 00 00 00       	mov    $0x3,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <pipe>:
SYSCALL(pipe)
 21d:	b8 04 00 00 00       	mov    $0x4,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <read>:
SYSCALL(read)
 225:	b8 05 00 00 00       	mov    $0x5,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <write>:
SYSCALL(write)
 22d:	b8 10 00 00 00       	mov    $0x10,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <close>:
SYSCALL(close)
 235:	b8 15 00 00 00       	mov    $0x15,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <kill>:
SYSCALL(kill)
 23d:	b8 06 00 00 00       	mov    $0x6,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <exec>:
SYSCALL(exec)
 245:	b8 07 00 00 00       	mov    $0x7,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <open>:
SYSCALL(open)
 24d:	b8 0f 00 00 00       	mov    $0xf,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <mknod>:
SYSCALL(mknod)
 255:	b8 11 00 00 00       	mov    $0x11,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <unlink>:
SYSCALL(unlink)
 25d:	b8 12 00 00 00       	mov    $0x12,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <fstat>:
SYSCALL(fstat)
 265:	b8 08 00 00 00       	mov    $0x8,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <link>:
SYSCALL(link)
 26d:	b8 13 00 00 00       	mov    $0x13,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <mkdir>:
SYSCALL(mkdir)
 275:	b8 14 00 00 00       	mov    $0x14,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <chdir>:
SYSCALL(chdir)
 27d:	b8 09 00 00 00       	mov    $0x9,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <dup>:
SYSCALL(dup)
 285:	b8 0a 00 00 00       	mov    $0xa,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <getpid>:
SYSCALL(getpid)
 28d:	b8 0b 00 00 00       	mov    $0xb,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <sbrk>:
SYSCALL(sbrk)
 295:	b8 0c 00 00 00       	mov    $0xc,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <sleep>:
SYSCALL(sleep)
 29d:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <uptime>:
SYSCALL(uptime)
 2a5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <settickets>:
SYSCALL(settickets)
 2ad:	b8 16 00 00 00       	mov    $0x16,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <getpinfo>:
SYSCALL(getpinfo)
 2b5:	b8 17 00 00 00       	mov    $0x17,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    
 2bd:	66 90                	xchg   %ax,%ax
 2bf:	90                   	nop

000002c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
 2c5:	53                   	push   %ebx
 2c6:	83 ec 3c             	sub    $0x3c,%esp
 2c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2cc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2cf:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2d4:	85 db                	test   %ebx,%ebx
 2d6:	74 04                	je     2dc <printint+0x1c>
 2d8:	85 d2                	test   %edx,%edx
 2da:	78 68                	js     344 <printint+0x84>
  neg = 0;
 2dc:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e3:	31 ff                	xor    %edi,%edi
 2e5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2e8:	89 c8                	mov    %ecx,%eax
 2ea:	31 d2                	xor    %edx,%edx
 2ec:	f7 75 c4             	divl   -0x3c(%ebp)
 2ef:	89 fb                	mov    %edi,%ebx
 2f1:	8d 7f 01             	lea    0x1(%edi),%edi
 2f4:	8a 92 84 06 00 00    	mov    0x684(%edx),%dl
 2fa:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 2fe:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 301:	89 c1                	mov    %eax,%ecx
 303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 306:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 309:	76 dd                	jbe    2e8 <printint+0x28>
  if(neg)
 30b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30e:	85 c9                	test   %ecx,%ecx
 310:	74 09                	je     31b <printint+0x5b>
    buf[i++] = '-';
 312:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 317:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 319:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 31b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 31f:	8b 7d bc             	mov    -0x44(%ebp),%edi
 322:	eb 03                	jmp    327 <printint+0x67>
 324:	8a 13                	mov    (%ebx),%dl
 326:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 327:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 32a:	50                   	push   %eax
 32b:	6a 01                	push   $0x1
 32d:	56                   	push   %esi
 32e:	57                   	push   %edi
 32f:	e8 f9 fe ff ff       	call   22d <write>
  while(--i >= 0)
 334:	83 c4 10             	add    $0x10,%esp
 337:	39 de                	cmp    %ebx,%esi
 339:	75 e9                	jne    324 <printint+0x64>
}
 33b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33e:	5b                   	pop    %ebx
 33f:	5e                   	pop    %esi
 340:	5f                   	pop    %edi
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	90                   	nop
    x = -xx;
 344:	f7 d9                	neg    %ecx
 346:	eb 9b                	jmp    2e3 <printint+0x23>

00000348 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
 34e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 351:	8b 75 0c             	mov    0xc(%ebp),%esi
 354:	8a 1e                	mov    (%esi),%bl
 356:	84 db                	test   %bl,%bl
 358:	0f 84 a3 00 00 00    	je     401 <printf+0xb9>
 35e:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 35f:	8d 45 10             	lea    0x10(%ebp),%eax
 362:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 365:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 367:	8d 7d e7             	lea    -0x19(%ebp),%edi
 36a:	eb 29                	jmp    395 <printf+0x4d>
 36c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 36f:	83 f8 25             	cmp    $0x25,%eax
 372:	0f 84 94 00 00 00    	je     40c <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 378:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 37b:	50                   	push   %eax
 37c:	6a 01                	push   $0x1
 37e:	57                   	push   %edi
 37f:	ff 75 08             	pushl  0x8(%ebp)
 382:	e8 a6 fe ff ff       	call   22d <write>
        putc(fd, c);
 387:	83 c4 10             	add    $0x10,%esp
 38a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 38d:	46                   	inc    %esi
 38e:	8a 5e ff             	mov    -0x1(%esi),%bl
 391:	84 db                	test   %bl,%bl
 393:	74 6c                	je     401 <printf+0xb9>
    c = fmt[i] & 0xff;
 395:	0f be cb             	movsbl %bl,%ecx
 398:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 39b:	85 d2                	test   %edx,%edx
 39d:	74 cd                	je     36c <printf+0x24>
      }
    } else if(state == '%'){
 39f:	83 fa 25             	cmp    $0x25,%edx
 3a2:	75 e9                	jne    38d <printf+0x45>
      if(c == 'd'){
 3a4:	83 f8 64             	cmp    $0x64,%eax
 3a7:	0f 84 97 00 00 00    	je     444 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3ad:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3b3:	83 f9 70             	cmp    $0x70,%ecx
 3b6:	74 60                	je     418 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3b8:	83 f8 73             	cmp    $0x73,%eax
 3bb:	0f 84 8f 00 00 00    	je     450 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3c1:	83 f8 63             	cmp    $0x63,%eax
 3c4:	0f 84 d6 00 00 00    	je     4a0 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3ca:	83 f8 25             	cmp    $0x25,%eax
 3cd:	0f 84 c1 00 00 00    	je     494 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3d3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3d7:	50                   	push   %eax
 3d8:	6a 01                	push   $0x1
 3da:	57                   	push   %edi
 3db:	ff 75 08             	pushl  0x8(%ebp)
 3de:	e8 4a fe ff ff       	call   22d <write>
        putc(fd, c);
 3e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3e6:	83 c4 0c             	add    $0xc,%esp
 3e9:	6a 01                	push   $0x1
 3eb:	57                   	push   %edi
 3ec:	ff 75 08             	pushl  0x8(%ebp)
 3ef:	e8 39 fe ff ff       	call   22d <write>
        putc(fd, c);
 3f4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 3f7:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 3f9:	46                   	inc    %esi
 3fa:	8a 5e ff             	mov    -0x1(%esi),%bl
 3fd:	84 db                	test   %bl,%bl
 3ff:	75 94                	jne    395 <printf+0x4d>
    }
  }
}
 401:	8d 65 f4             	lea    -0xc(%ebp),%esp
 404:	5b                   	pop    %ebx
 405:	5e                   	pop    %esi
 406:	5f                   	pop    %edi
 407:	5d                   	pop    %ebp
 408:	c3                   	ret    
 409:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 40c:	ba 25 00 00 00       	mov    $0x25,%edx
 411:	e9 77 ff ff ff       	jmp    38d <printf+0x45>
 416:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 418:	83 ec 0c             	sub    $0xc,%esp
 41b:	6a 00                	push   $0x0
 41d:	b9 10 00 00 00       	mov    $0x10,%ecx
 422:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 425:	8b 13                	mov    (%ebx),%edx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	e8 91 fe ff ff       	call   2c0 <printint>
        ap++;
 42f:	89 d8                	mov    %ebx,%eax
 431:	83 c0 04             	add    $0x4,%eax
 434:	89 45 d0             	mov    %eax,-0x30(%ebp)
 437:	83 c4 10             	add    $0x10,%esp
      state = 0;
 43a:	31 d2                	xor    %edx,%edx
        ap++;
 43c:	e9 4c ff ff ff       	jmp    38d <printf+0x45>
 441:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 444:	83 ec 0c             	sub    $0xc,%esp
 447:	6a 01                	push   $0x1
 449:	b9 0a 00 00 00       	mov    $0xa,%ecx
 44e:	eb d2                	jmp    422 <printf+0xda>
        s = (char*)*ap;
 450:	8b 45 d0             	mov    -0x30(%ebp),%eax
 453:	8b 18                	mov    (%eax),%ebx
        ap++;
 455:	83 c0 04             	add    $0x4,%eax
 458:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 45b:	85 db                	test   %ebx,%ebx
 45d:	74 65                	je     4c4 <printf+0x17c>
        while(*s != 0){
 45f:	8a 03                	mov    (%ebx),%al
 461:	84 c0                	test   %al,%al
 463:	74 70                	je     4d5 <printf+0x18d>
 465:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 468:	89 de                	mov    %ebx,%esi
 46a:	8b 5d 08             	mov    0x8(%ebp),%ebx
 46d:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 470:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 473:	50                   	push   %eax
 474:	6a 01                	push   $0x1
 476:	57                   	push   %edi
 477:	53                   	push   %ebx
 478:	e8 b0 fd ff ff       	call   22d <write>
          s++;
 47d:	46                   	inc    %esi
        while(*s != 0){
 47e:	8a 06                	mov    (%esi),%al
 480:	83 c4 10             	add    $0x10,%esp
 483:	84 c0                	test   %al,%al
 485:	75 e9                	jne    470 <printf+0x128>
 487:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 48a:	31 d2                	xor    %edx,%edx
 48c:	e9 fc fe ff ff       	jmp    38d <printf+0x45>
 491:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 494:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 497:	52                   	push   %edx
 498:	e9 4c ff ff ff       	jmp    3e9 <printf+0xa1>
 49d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4a3:	8b 03                	mov    (%ebx),%eax
 4a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a8:	51                   	push   %ecx
 4a9:	6a 01                	push   $0x1
 4ab:	57                   	push   %edi
 4ac:	ff 75 08             	pushl  0x8(%ebp)
 4af:	e8 79 fd ff ff       	call   22d <write>
        ap++;
 4b4:	83 c3 04             	add    $0x4,%ebx
 4b7:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4bd:	31 d2                	xor    %edx,%edx
 4bf:	e9 c9 fe ff ff       	jmp    38d <printf+0x45>
          s = "(null)";
 4c4:	bb 7b 06 00 00       	mov    $0x67b,%ebx
        while(*s != 0){
 4c9:	b0 28                	mov    $0x28,%al
 4cb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4ce:	89 de                	mov    %ebx,%esi
 4d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4d3:	eb 9b                	jmp    470 <printf+0x128>
      state = 0;
 4d5:	31 d2                	xor    %edx,%edx
 4d7:	e9 b1 fe ff ff       	jmp    38d <printf+0x45>

000004dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	57                   	push   %edi
 4e0:	56                   	push   %esi
 4e1:	53                   	push   %ebx
 4e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e8:	a1 20 09 00 00       	mov    0x920,%eax
 4ed:	8b 10                	mov    (%eax),%edx
 4ef:	39 c8                	cmp    %ecx,%eax
 4f1:	73 11                	jae    504 <free+0x28>
 4f3:	90                   	nop
 4f4:	39 d1                	cmp    %edx,%ecx
 4f6:	72 14                	jb     50c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f8:	39 d0                	cmp    %edx,%eax
 4fa:	73 10                	jae    50c <free+0x30>
{
 4fc:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fe:	8b 10                	mov    (%eax),%edx
 500:	39 c8                	cmp    %ecx,%eax
 502:	72 f0                	jb     4f4 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 504:	39 d0                	cmp    %edx,%eax
 506:	72 f4                	jb     4fc <free+0x20>
 508:	39 d1                	cmp    %edx,%ecx
 50a:	73 f0                	jae    4fc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 50c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 50f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 512:	39 fa                	cmp    %edi,%edx
 514:	74 1a                	je     530 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 516:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 519:	8b 50 04             	mov    0x4(%eax),%edx
 51c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 51f:	39 f1                	cmp    %esi,%ecx
 521:	74 24                	je     547 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 523:	89 08                	mov    %ecx,(%eax)
  freep = p;
 525:	a3 20 09 00 00       	mov    %eax,0x920
}
 52a:	5b                   	pop    %ebx
 52b:	5e                   	pop    %esi
 52c:	5f                   	pop    %edi
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    
 52f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 530:	03 72 04             	add    0x4(%edx),%esi
 533:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 536:	8b 10                	mov    (%eax),%edx
 538:	8b 12                	mov    (%edx),%edx
 53a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 53d:	8b 50 04             	mov    0x4(%eax),%edx
 540:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 543:	39 f1                	cmp    %esi,%ecx
 545:	75 dc                	jne    523 <free+0x47>
    p->s.size += bp->s.size;
 547:	03 53 fc             	add    -0x4(%ebx),%edx
 54a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 54d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 550:	89 10                	mov    %edx,(%eax)
  freep = p;
 552:	a3 20 09 00 00       	mov    %eax,0x920
}
 557:	5b                   	pop    %ebx
 558:	5e                   	pop    %esi
 559:	5f                   	pop    %edi
 55a:	5d                   	pop    %ebp
 55b:	c3                   	ret    

0000055c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	53                   	push   %ebx
 562:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	8d 70 07             	lea    0x7(%eax),%esi
 56b:	c1 ee 03             	shr    $0x3,%esi
 56e:	46                   	inc    %esi
  if((prevp = freep) == 0){
 56f:	8b 3d 20 09 00 00    	mov    0x920,%edi
 575:	85 ff                	test   %edi,%edi
 577:	0f 84 a3 00 00 00    	je     620 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 57d:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 57f:	8b 48 04             	mov    0x4(%eax),%ecx
 582:	39 f1                	cmp    %esi,%ecx
 584:	73 67                	jae    5ed <malloc+0x91>
 586:	89 f3                	mov    %esi,%ebx
 588:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 58e:	0f 82 80 00 00 00    	jb     614 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 594:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 59b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 59e:	eb 11                	jmp    5b1 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5a2:	8b 4a 04             	mov    0x4(%edx),%ecx
 5a5:	39 f1                	cmp    %esi,%ecx
 5a7:	73 4b                	jae    5f4 <malloc+0x98>
 5a9:	8b 3d 20 09 00 00    	mov    0x920,%edi
 5af:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5b1:	39 c7                	cmp    %eax,%edi
 5b3:	75 eb                	jne    5a0 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5b5:	83 ec 0c             	sub    $0xc,%esp
 5b8:	ff 75 e4             	pushl  -0x1c(%ebp)
 5bb:	e8 d5 fc ff ff       	call   295 <sbrk>
  if(p == (char*)-1)
 5c0:	83 c4 10             	add    $0x10,%esp
 5c3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c6:	74 1b                	je     5e3 <malloc+0x87>
  hp->s.size = nu;
 5c8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5cb:	83 ec 0c             	sub    $0xc,%esp
 5ce:	83 c0 08             	add    $0x8,%eax
 5d1:	50                   	push   %eax
 5d2:	e8 05 ff ff ff       	call   4dc <free>
  return freep;
 5d7:	a1 20 09 00 00       	mov    0x920,%eax
      if((p = morecore(nunits)) == 0)
 5dc:	83 c4 10             	add    $0x10,%esp
 5df:	85 c0                	test   %eax,%eax
 5e1:	75 bd                	jne    5a0 <malloc+0x44>
        return 0;
 5e3:	31 c0                	xor    %eax,%eax
  }
}
 5e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e8:	5b                   	pop    %ebx
 5e9:	5e                   	pop    %esi
 5ea:	5f                   	pop    %edi
 5eb:	5d                   	pop    %ebp
 5ec:	c3                   	ret    
    if(p->s.size >= nunits){
 5ed:	89 c2                	mov    %eax,%edx
 5ef:	89 f8                	mov    %edi,%eax
 5f1:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 5f4:	39 ce                	cmp    %ecx,%esi
 5f6:	74 54                	je     64c <malloc+0xf0>
        p->s.size -= nunits;
 5f8:	29 f1                	sub    %esi,%ecx
 5fa:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 5fd:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 600:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 603:	a3 20 09 00 00       	mov    %eax,0x920
      return (void*)(p + 1);
 608:	8d 42 08             	lea    0x8(%edx),%eax
}
 60b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60e:	5b                   	pop    %ebx
 60f:	5e                   	pop    %esi
 610:	5f                   	pop    %edi
 611:	5d                   	pop    %ebp
 612:	c3                   	ret    
 613:	90                   	nop
 614:	bb 00 10 00 00       	mov    $0x1000,%ebx
 619:	e9 76 ff ff ff       	jmp    594 <malloc+0x38>
 61e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 620:	c7 05 20 09 00 00 24 	movl   $0x924,0x920
 627:	09 00 00 
 62a:	c7 05 24 09 00 00 24 	movl   $0x924,0x924
 631:	09 00 00 
    base.s.size = 0;
 634:	c7 05 28 09 00 00 00 	movl   $0x0,0x928
 63b:	00 00 00 
 63e:	bf 24 09 00 00       	mov    $0x924,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 643:	89 f8                	mov    %edi,%eax
 645:	e9 3c ff ff ff       	jmp    586 <malloc+0x2a>
 64a:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 64c:	8b 0a                	mov    (%edx),%ecx
 64e:	89 08                	mov    %ecx,(%eax)
 650:	eb b1                	jmp    603 <malloc+0xa7>
