
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 28                	jle    45 <main+0x45>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 33                	pushl  (%ebx)
  29:	e8 7e 01 00 00       	call   1ac <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 03 02 00 00       	call   239 <kill>
  for(i=1; i<argc; i++)
  36:	83 c3 04             	add    $0x4,%ebx
  39:	83 c4 10             	add    $0x10,%esp
  3c:	39 f3                	cmp    %esi,%ebx
  3e:	75 e4                	jne    24 <main+0x24>
  exit();
  40:	e8 c4 01 00 00       	call   209 <exit>
    printf(2, "usage: kill pid...\n");
  45:	50                   	push   %eax
  46:	50                   	push   %eax
  47:	68 50 06 00 00       	push   $0x650
  4c:	6a 02                	push   $0x2
  4e:	e8 f1 02 00 00       	call   344 <printf>
    exit();
  53:	e8 b1 01 00 00       	call   209 <exit>

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	31 c0                	xor    %eax,%eax
  64:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  67:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6a:	40                   	inc    %eax
  6b:	84 d2                	test   %dl,%dl
  6d:	75 f5                	jne    64 <strcpy+0xc>
    ;
  return os;
}
  6f:	89 c8                	mov    %ecx,%eax
  71:	5b                   	pop    %ebx
  72:	5d                   	pop    %ebp
  73:	c3                   	ret    

00000074 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	53                   	push   %ebx
  78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  7e:	0f b6 03             	movzbl (%ebx),%eax
  81:	0f b6 0a             	movzbl (%edx),%ecx
  84:	84 c0                	test   %al,%al
  86:	75 10                	jne    98 <strcmp+0x24>
  88:	eb 1a                	jmp    a4 <strcmp+0x30>
  8a:	66 90                	xchg   %ax,%ax
    p++, q++;
  8c:	43                   	inc    %ebx
  8d:	42                   	inc    %edx
  while(*p && *p == *q)
  8e:	0f b6 03             	movzbl (%ebx),%eax
  91:	0f b6 0a             	movzbl (%edx),%ecx
  94:	84 c0                	test   %al,%al
  96:	74 0c                	je     a4 <strcmp+0x30>
  98:	38 c8                	cmp    %cl,%al
  9a:	74 f0                	je     8c <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  9c:	29 c8                	sub    %ecx,%eax
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	8d 76 00             	lea    0x0(%esi),%esi
  a4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  a6:	29 c8                	sub    %ecx,%eax
}
  a8:	5b                   	pop    %ebx
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    
  ab:	90                   	nop

000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b2:	80 3a 00             	cmpb   $0x0,(%edx)
  b5:	74 15                	je     cc <strlen+0x20>
  b7:	31 c0                	xor    %eax,%eax
  b9:	8d 76 00             	lea    0x0(%esi),%esi
  bc:	40                   	inc    %eax
  bd:	89 c1                	mov    %eax,%ecx
  bf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c3:	75 f7                	jne    bc <strlen+0x10>
    ;
  return n;
}
  c5:	89 c8                	mov    %ecx,%eax
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  cc:	31 c9                	xor    %ecx,%ecx
}
  ce:	89 c8                	mov    %ecx,%eax
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    
  d2:	66 90                	xchg   %ax,%ax

000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	fc                   	cld    
  e2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    
  ea:	66 90                	xchg   %ax,%ax

000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f5:	8a 10                	mov    (%eax),%dl
  f7:	84 d2                	test   %dl,%dl
  f9:	75 0c                	jne    107 <strchr+0x1b>
  fb:	eb 13                	jmp    110 <strchr+0x24>
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	40                   	inc    %eax
 101:	8a 10                	mov    (%eax),%dl
 103:	84 d2                	test   %dl,%dl
 105:	74 09                	je     110 <strchr+0x24>
    if(*s == c)
 107:	38 d1                	cmp    %dl,%cl
 109:	75 f5                	jne    100 <strchr+0x14>
      return (char*)s;
  return 0;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <gets>:

char*
gets(char *buf, int max)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11d:	8b 75 08             	mov    0x8(%ebp),%esi
 120:	bb 01 00 00 00       	mov    $0x1,%ebx
 125:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 127:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12a:	eb 20                	jmp    14c <gets+0x38>
    cc = read(0, &c, 1);
 12c:	50                   	push   %eax
 12d:	6a 01                	push   $0x1
 12f:	57                   	push   %edi
 130:	6a 00                	push   $0x0
 132:	e8 ea 00 00 00       	call   221 <read>
    if(cc < 1)
 137:	83 c4 10             	add    $0x10,%esp
 13a:	85 c0                	test   %eax,%eax
 13c:	7e 16                	jle    154 <gets+0x40>
      break;
    buf[i++] = c;
 13e:	8a 45 e7             	mov    -0x19(%ebp),%al
 141:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 143:	46                   	inc    %esi
 144:	3c 0a                	cmp    $0xa,%al
 146:	74 0c                	je     154 <gets+0x40>
 148:	3c 0d                	cmp    $0xd,%al
 14a:	74 08                	je     154 <gets+0x40>
  for(i=0; i+1 < max; ){
 14c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 14f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 152:	7f d8                	jg     12c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 154:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15d:	5b                   	pop    %ebx
 15e:	5e                   	pop    %esi
 15f:	5f                   	pop    %edi
 160:	5d                   	pop    %ebp
 161:	c3                   	ret    
 162:	66 90                	xchg   %ax,%ax

00000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	56                   	push   %esi
 168:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	6a 00                	push   $0x0
 16e:	ff 75 08             	pushl  0x8(%ebp)
 171:	e8 d3 00 00 00       	call   249 <open>
  if(fd < 0)
 176:	83 c4 10             	add    $0x10,%esp
 179:	85 c0                	test   %eax,%eax
 17b:	78 27                	js     1a4 <stat+0x40>
 17d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	ff 75 0c             	pushl  0xc(%ebp)
 185:	50                   	push   %eax
 186:	e8 d6 00 00 00       	call   261 <fstat>
 18b:	89 c6                	mov    %eax,%esi
  close(fd);
 18d:	89 1c 24             	mov    %ebx,(%esp)
 190:	e8 9c 00 00 00       	call   231 <close>
  return r;
 195:	83 c4 10             	add    $0x10,%esp
}
 198:	89 f0                	mov    %esi,%eax
 19a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
 1a1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1a4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a9:	eb ed                	jmp    198 <stat+0x34>
 1ab:	90                   	nop

000001ac <atoi>:

int
atoi(const char *s)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	53                   	push   %ebx
 1b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b3:	0f be 01             	movsbl (%ecx),%eax
 1b6:	8d 50 d0             	lea    -0x30(%eax),%edx
 1b9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1bc:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c1:	77 16                	ja     1d9 <atoi+0x2d>
 1c3:	90                   	nop
    n = n*10 + *s++ - '0';
 1c4:	41                   	inc    %ecx
 1c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1c8:	01 d2                	add    %edx,%edx
 1ca:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1ce:	0f be 01             	movsbl (%ecx),%eax
 1d1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1d4:	80 fb 09             	cmp    $0x9,%bl
 1d7:	76 eb                	jbe    1c4 <atoi+0x18>
  return n;
}
 1d9:	89 d0                	mov    %edx,%eax
 1db:	5b                   	pop    %ebx
 1dc:	5d                   	pop    %ebp
 1dd:	c3                   	ret    
 1de:	66 90                	xchg   %ax,%ax

000001e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8b 75 0c             	mov    0xc(%ebp),%esi
 1eb:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ee:	85 d2                	test   %edx,%edx
 1f0:	7e 0b                	jle    1fd <memmove+0x1d>
 1f2:	01 c2                	add    %eax,%edx
  dst = vdst;
 1f4:	89 c7                	mov    %eax,%edi
 1f6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 1f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 1f9:	39 fa                	cmp    %edi,%edx
 1fb:	75 fb                	jne    1f8 <memmove+0x18>
  return vdst;
}
 1fd:	5e                   	pop    %esi
 1fe:	5f                   	pop    %edi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 201:	b8 01 00 00 00       	mov    $0x1,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	ret    

00000209 <exit>:
SYSCALL(exit)
 209:	b8 02 00 00 00       	mov    $0x2,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	ret    

00000211 <wait>:
SYSCALL(wait)
 211:	b8 03 00 00 00       	mov    $0x3,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	ret    

00000219 <pipe>:
SYSCALL(pipe)
 219:	b8 04 00 00 00       	mov    $0x4,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <read>:
SYSCALL(read)
 221:	b8 05 00 00 00       	mov    $0x5,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <write>:
SYSCALL(write)
 229:	b8 10 00 00 00       	mov    $0x10,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <close>:
SYSCALL(close)
 231:	b8 15 00 00 00       	mov    $0x15,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <kill>:
SYSCALL(kill)
 239:	b8 06 00 00 00       	mov    $0x6,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <exec>:
SYSCALL(exec)
 241:	b8 07 00 00 00       	mov    $0x7,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <open>:
SYSCALL(open)
 249:	b8 0f 00 00 00       	mov    $0xf,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <mknod>:
SYSCALL(mknod)
 251:	b8 11 00 00 00       	mov    $0x11,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <unlink>:
SYSCALL(unlink)
 259:	b8 12 00 00 00       	mov    $0x12,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <fstat>:
SYSCALL(fstat)
 261:	b8 08 00 00 00       	mov    $0x8,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <link>:
SYSCALL(link)
 269:	b8 13 00 00 00       	mov    $0x13,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <mkdir>:
SYSCALL(mkdir)
 271:	b8 14 00 00 00       	mov    $0x14,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <chdir>:
SYSCALL(chdir)
 279:	b8 09 00 00 00       	mov    $0x9,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <dup>:
SYSCALL(dup)
 281:	b8 0a 00 00 00       	mov    $0xa,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <getpid>:
SYSCALL(getpid)
 289:	b8 0b 00 00 00       	mov    $0xb,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <sbrk>:
SYSCALL(sbrk)
 291:	b8 0c 00 00 00       	mov    $0xc,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <sleep>:
SYSCALL(sleep)
 299:	b8 0d 00 00 00       	mov    $0xd,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <uptime>:
SYSCALL(uptime)
 2a1:	b8 0e 00 00 00       	mov    $0xe,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <settickets>:
SYSCALL(settickets)
 2a9:	b8 16 00 00 00       	mov    $0x16,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <getpinfo>:
SYSCALL(getpinfo)
 2b1:	b8 17 00 00 00       	mov    $0x17,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    
 2b9:	66 90                	xchg   %ax,%ax
 2bb:	90                   	nop

000002bc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	57                   	push   %edi
 2c0:	56                   	push   %esi
 2c1:	53                   	push   %ebx
 2c2:	83 ec 3c             	sub    $0x3c,%esp
 2c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2c8:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2cb:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2d0:	85 db                	test   %ebx,%ebx
 2d2:	74 04                	je     2d8 <printint+0x1c>
 2d4:	85 d2                	test   %edx,%edx
 2d6:	78 68                	js     340 <printint+0x84>
  neg = 0;
 2d8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2df:	31 ff                	xor    %edi,%edi
 2e1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2e4:	89 c8                	mov    %ecx,%eax
 2e6:	31 d2                	xor    %edx,%edx
 2e8:	f7 75 c4             	divl   -0x3c(%ebp)
 2eb:	89 fb                	mov    %edi,%ebx
 2ed:	8d 7f 01             	lea    0x1(%edi),%edi
 2f0:	8a 92 6c 06 00 00    	mov    0x66c(%edx),%dl
 2f6:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 2fa:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 2fd:	89 c1                	mov    %eax,%ecx
 2ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 302:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 305:	76 dd                	jbe    2e4 <printint+0x28>
  if(neg)
 307:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30a:	85 c9                	test   %ecx,%ecx
 30c:	74 09                	je     317 <printint+0x5b>
    buf[i++] = '-';
 30e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 313:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 315:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 317:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 31b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 31e:	eb 03                	jmp    323 <printint+0x67>
 320:	8a 13                	mov    (%ebx),%dl
 322:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 323:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 326:	50                   	push   %eax
 327:	6a 01                	push   $0x1
 329:	56                   	push   %esi
 32a:	57                   	push   %edi
 32b:	e8 f9 fe ff ff       	call   229 <write>
  while(--i >= 0)
 330:	83 c4 10             	add    $0x10,%esp
 333:	39 de                	cmp    %ebx,%esi
 335:	75 e9                	jne    320 <printint+0x64>
}
 337:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33a:	5b                   	pop    %ebx
 33b:	5e                   	pop    %esi
 33c:	5f                   	pop    %edi
 33d:	5d                   	pop    %ebp
 33e:	c3                   	ret    
 33f:	90                   	nop
    x = -xx;
 340:	f7 d9                	neg    %ecx
 342:	eb 9b                	jmp    2df <printint+0x23>

00000344 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
 349:	53                   	push   %ebx
 34a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 34d:	8b 75 0c             	mov    0xc(%ebp),%esi
 350:	8a 1e                	mov    (%esi),%bl
 352:	84 db                	test   %bl,%bl
 354:	0f 84 a3 00 00 00    	je     3fd <printf+0xb9>
 35a:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 35b:	8d 45 10             	lea    0x10(%ebp),%eax
 35e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 361:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 363:	8d 7d e7             	lea    -0x19(%ebp),%edi
 366:	eb 29                	jmp    391 <printf+0x4d>
 368:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 36b:	83 f8 25             	cmp    $0x25,%eax
 36e:	0f 84 94 00 00 00    	je     408 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 374:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 377:	50                   	push   %eax
 378:	6a 01                	push   $0x1
 37a:	57                   	push   %edi
 37b:	ff 75 08             	pushl  0x8(%ebp)
 37e:	e8 a6 fe ff ff       	call   229 <write>
        putc(fd, c);
 383:	83 c4 10             	add    $0x10,%esp
 386:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 389:	46                   	inc    %esi
 38a:	8a 5e ff             	mov    -0x1(%esi),%bl
 38d:	84 db                	test   %bl,%bl
 38f:	74 6c                	je     3fd <printf+0xb9>
    c = fmt[i] & 0xff;
 391:	0f be cb             	movsbl %bl,%ecx
 394:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 397:	85 d2                	test   %edx,%edx
 399:	74 cd                	je     368 <printf+0x24>
      }
    } else if(state == '%'){
 39b:	83 fa 25             	cmp    $0x25,%edx
 39e:	75 e9                	jne    389 <printf+0x45>
      if(c == 'd'){
 3a0:	83 f8 64             	cmp    $0x64,%eax
 3a3:	0f 84 97 00 00 00    	je     440 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3a9:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3af:	83 f9 70             	cmp    $0x70,%ecx
 3b2:	74 60                	je     414 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3b4:	83 f8 73             	cmp    $0x73,%eax
 3b7:	0f 84 8f 00 00 00    	je     44c <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3bd:	83 f8 63             	cmp    $0x63,%eax
 3c0:	0f 84 d6 00 00 00    	je     49c <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3c6:	83 f8 25             	cmp    $0x25,%eax
 3c9:	0f 84 c1 00 00 00    	je     490 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3d3:	50                   	push   %eax
 3d4:	6a 01                	push   $0x1
 3d6:	57                   	push   %edi
 3d7:	ff 75 08             	pushl  0x8(%ebp)
 3da:	e8 4a fe ff ff       	call   229 <write>
        putc(fd, c);
 3df:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3e2:	83 c4 0c             	add    $0xc,%esp
 3e5:	6a 01                	push   $0x1
 3e7:	57                   	push   %edi
 3e8:	ff 75 08             	pushl  0x8(%ebp)
 3eb:	e8 39 fe ff ff       	call   229 <write>
        putc(fd, c);
 3f0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 3f3:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 3f5:	46                   	inc    %esi
 3f6:	8a 5e ff             	mov    -0x1(%esi),%bl
 3f9:	84 db                	test   %bl,%bl
 3fb:	75 94                	jne    391 <printf+0x4d>
    }
  }
}
 3fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 400:	5b                   	pop    %ebx
 401:	5e                   	pop    %esi
 402:	5f                   	pop    %edi
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    
 405:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 408:	ba 25 00 00 00       	mov    $0x25,%edx
 40d:	e9 77 ff ff ff       	jmp    389 <printf+0x45>
 412:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 414:	83 ec 0c             	sub    $0xc,%esp
 417:	6a 00                	push   $0x0
 419:	b9 10 00 00 00       	mov    $0x10,%ecx
 41e:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 421:	8b 13                	mov    (%ebx),%edx
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	e8 91 fe ff ff       	call   2bc <printint>
        ap++;
 42b:	89 d8                	mov    %ebx,%eax
 42d:	83 c0 04             	add    $0x4,%eax
 430:	89 45 d0             	mov    %eax,-0x30(%ebp)
 433:	83 c4 10             	add    $0x10,%esp
      state = 0;
 436:	31 d2                	xor    %edx,%edx
        ap++;
 438:	e9 4c ff ff ff       	jmp    389 <printf+0x45>
 43d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 01                	push   $0x1
 445:	b9 0a 00 00 00       	mov    $0xa,%ecx
 44a:	eb d2                	jmp    41e <printf+0xda>
        s = (char*)*ap;
 44c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 44f:	8b 18                	mov    (%eax),%ebx
        ap++;
 451:	83 c0 04             	add    $0x4,%eax
 454:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 457:	85 db                	test   %ebx,%ebx
 459:	74 65                	je     4c0 <printf+0x17c>
        while(*s != 0){
 45b:	8a 03                	mov    (%ebx),%al
 45d:	84 c0                	test   %al,%al
 45f:	74 70                	je     4d1 <printf+0x18d>
 461:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 464:	89 de                	mov    %ebx,%esi
 466:	8b 5d 08             	mov    0x8(%ebp),%ebx
 469:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 46c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 46f:	50                   	push   %eax
 470:	6a 01                	push   $0x1
 472:	57                   	push   %edi
 473:	53                   	push   %ebx
 474:	e8 b0 fd ff ff       	call   229 <write>
          s++;
 479:	46                   	inc    %esi
        while(*s != 0){
 47a:	8a 06                	mov    (%esi),%al
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	84 c0                	test   %al,%al
 481:	75 e9                	jne    46c <printf+0x128>
 483:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 486:	31 d2                	xor    %edx,%edx
 488:	e9 fc fe ff ff       	jmp    389 <printf+0x45>
 48d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 490:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 493:	52                   	push   %edx
 494:	e9 4c ff ff ff       	jmp    3e5 <printf+0xa1>
 499:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 49c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 49f:	8b 03                	mov    (%ebx),%eax
 4a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4a4:	51                   	push   %ecx
 4a5:	6a 01                	push   $0x1
 4a7:	57                   	push   %edi
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 79 fd ff ff       	call   229 <write>
        ap++;
 4b0:	83 c3 04             	add    $0x4,%ebx
 4b3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b9:	31 d2                	xor    %edx,%edx
 4bb:	e9 c9 fe ff ff       	jmp    389 <printf+0x45>
          s = "(null)";
 4c0:	bb 64 06 00 00       	mov    $0x664,%ebx
        while(*s != 0){
 4c5:	b0 28                	mov    $0x28,%al
 4c7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4ca:	89 de                	mov    %ebx,%esi
 4cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4cf:	eb 9b                	jmp    46c <printf+0x128>
      state = 0;
 4d1:	31 d2                	xor    %edx,%edx
 4d3:	e9 b1 fe ff ff       	jmp    389 <printf+0x45>

000004d8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	57                   	push   %edi
 4dc:	56                   	push   %esi
 4dd:	53                   	push   %ebx
 4de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4e1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e4:	a1 0c 09 00 00       	mov    0x90c,%eax
 4e9:	8b 10                	mov    (%eax),%edx
 4eb:	39 c8                	cmp    %ecx,%eax
 4ed:	73 11                	jae    500 <free+0x28>
 4ef:	90                   	nop
 4f0:	39 d1                	cmp    %edx,%ecx
 4f2:	72 14                	jb     508 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f4:	39 d0                	cmp    %edx,%eax
 4f6:	73 10                	jae    508 <free+0x30>
{
 4f8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fa:	8b 10                	mov    (%eax),%edx
 4fc:	39 c8                	cmp    %ecx,%eax
 4fe:	72 f0                	jb     4f0 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 500:	39 d0                	cmp    %edx,%eax
 502:	72 f4                	jb     4f8 <free+0x20>
 504:	39 d1                	cmp    %edx,%ecx
 506:	73 f0                	jae    4f8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 508:	8b 73 fc             	mov    -0x4(%ebx),%esi
 50b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 50e:	39 fa                	cmp    %edi,%edx
 510:	74 1a                	je     52c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 512:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 515:	8b 50 04             	mov    0x4(%eax),%edx
 518:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 51b:	39 f1                	cmp    %esi,%ecx
 51d:	74 24                	je     543 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 51f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 521:	a3 0c 09 00 00       	mov    %eax,0x90c
}
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5f                   	pop    %edi
 529:	5d                   	pop    %ebp
 52a:	c3                   	ret    
 52b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 52c:	03 72 04             	add    0x4(%edx),%esi
 52f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 532:	8b 10                	mov    (%eax),%edx
 534:	8b 12                	mov    (%edx),%edx
 536:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 539:	8b 50 04             	mov    0x4(%eax),%edx
 53c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 53f:	39 f1                	cmp    %esi,%ecx
 541:	75 dc                	jne    51f <free+0x47>
    p->s.size += bp->s.size;
 543:	03 53 fc             	add    -0x4(%ebx),%edx
 546:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 549:	8b 53 f8             	mov    -0x8(%ebx),%edx
 54c:	89 10                	mov    %edx,(%eax)
  freep = p;
 54e:	a3 0c 09 00 00       	mov    %eax,0x90c
}
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    

00000558 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 561:	8b 45 08             	mov    0x8(%ebp),%eax
 564:	8d 70 07             	lea    0x7(%eax),%esi
 567:	c1 ee 03             	shr    $0x3,%esi
 56a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 56b:	8b 3d 0c 09 00 00    	mov    0x90c,%edi
 571:	85 ff                	test   %edi,%edi
 573:	0f 84 a3 00 00 00    	je     61c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 579:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 57b:	8b 48 04             	mov    0x4(%eax),%ecx
 57e:	39 f1                	cmp    %esi,%ecx
 580:	73 67                	jae    5e9 <malloc+0x91>
 582:	89 f3                	mov    %esi,%ebx
 584:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 58a:	0f 82 80 00 00 00    	jb     610 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 590:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 597:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 59a:	eb 11                	jmp    5ad <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 59c:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 59e:	8b 4a 04             	mov    0x4(%edx),%ecx
 5a1:	39 f1                	cmp    %esi,%ecx
 5a3:	73 4b                	jae    5f0 <malloc+0x98>
 5a5:	8b 3d 0c 09 00 00    	mov    0x90c,%edi
 5ab:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5ad:	39 c7                	cmp    %eax,%edi
 5af:	75 eb                	jne    59c <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5b1:	83 ec 0c             	sub    $0xc,%esp
 5b4:	ff 75 e4             	pushl  -0x1c(%ebp)
 5b7:	e8 d5 fc ff ff       	call   291 <sbrk>
  if(p == (char*)-1)
 5bc:	83 c4 10             	add    $0x10,%esp
 5bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c2:	74 1b                	je     5df <malloc+0x87>
  hp->s.size = nu;
 5c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5c7:	83 ec 0c             	sub    $0xc,%esp
 5ca:	83 c0 08             	add    $0x8,%eax
 5cd:	50                   	push   %eax
 5ce:	e8 05 ff ff ff       	call   4d8 <free>
  return freep;
 5d3:	a1 0c 09 00 00       	mov    0x90c,%eax
      if((p = morecore(nunits)) == 0)
 5d8:	83 c4 10             	add    $0x10,%esp
 5db:	85 c0                	test   %eax,%eax
 5dd:	75 bd                	jne    59c <malloc+0x44>
        return 0;
 5df:	31 c0                	xor    %eax,%eax
  }
}
 5e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e4:	5b                   	pop    %ebx
 5e5:	5e                   	pop    %esi
 5e6:	5f                   	pop    %edi
 5e7:	5d                   	pop    %ebp
 5e8:	c3                   	ret    
    if(p->s.size >= nunits){
 5e9:	89 c2                	mov    %eax,%edx
 5eb:	89 f8                	mov    %edi,%eax
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 5f0:	39 ce                	cmp    %ecx,%esi
 5f2:	74 54                	je     648 <malloc+0xf0>
        p->s.size -= nunits;
 5f4:	29 f1                	sub    %esi,%ecx
 5f6:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 5f9:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 5fc:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 5ff:	a3 0c 09 00 00       	mov    %eax,0x90c
      return (void*)(p + 1);
 604:	8d 42 08             	lea    0x8(%edx),%eax
}
 607:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60a:	5b                   	pop    %ebx
 60b:	5e                   	pop    %esi
 60c:	5f                   	pop    %edi
 60d:	5d                   	pop    %ebp
 60e:	c3                   	ret    
 60f:	90                   	nop
 610:	bb 00 10 00 00       	mov    $0x1000,%ebx
 615:	e9 76 ff ff ff       	jmp    590 <malloc+0x38>
 61a:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 61c:	c7 05 0c 09 00 00 10 	movl   $0x910,0x90c
 623:	09 00 00 
 626:	c7 05 10 09 00 00 10 	movl   $0x910,0x910
 62d:	09 00 00 
    base.s.size = 0;
 630:	c7 05 14 09 00 00 00 	movl   $0x0,0x914
 637:	00 00 00 
 63a:	bf 10 09 00 00       	mov    $0x910,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 63f:	89 f8                	mov    %edi,%eax
 641:	e9 3c ff ff ff       	jmp    582 <malloc+0x2a>
 646:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 648:	8b 0a                	mov    (%edx),%ecx
 64a:	89 08                	mov    %ecx,(%eax)
 64c:	eb b1                	jmp    5ff <malloc+0xa7>
