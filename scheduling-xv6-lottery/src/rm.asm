
_rm:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 3c                	jle    5a <main+0x5a>
  1e:	83 c3 04             	add    $0x4,%ebx
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bf 01 00 00 00       	mov    $0x1,%edi
  26:	66 90                	xchg   %ax,%ax
    if(unlink(argv[i]) < 0){
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	e8 3f 02 00 00       	call   271 <unlink>
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	78 0d                	js     46 <main+0x46>
  for(i = 1; i < argc; i++){
  39:	47                   	inc    %edi
  3a:	83 c3 04             	add    $0x4,%ebx
  3d:	39 fe                	cmp    %edi,%esi
  3f:	75 e7                	jne    28 <main+0x28>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  41:	e8 db 01 00 00       	call   221 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  46:	50                   	push   %eax
  47:	ff 33                	pushl  (%ebx)
  49:	68 7c 06 00 00       	push   $0x67c
  4e:	6a 02                	push   $0x2
  50:	e8 07 03 00 00       	call   35c <printf>
      break;
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e7                	jmp    41 <main+0x41>
    printf(2, "Usage: rm files...\n");
  5a:	52                   	push   %edx
  5b:	52                   	push   %edx
  5c:	68 68 06 00 00       	push   $0x668
  61:	6a 02                	push   $0x2
  63:	e8 f4 02 00 00       	call   35c <printf>
    exit();
  68:	e8 b4 01 00 00       	call   221 <exit>
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	31 c0                	xor    %eax,%eax
  7c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  7f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  82:	40                   	inc    %eax
  83:	84 d2                	test   %dl,%dl
  85:	75 f5                	jne    7c <strcpy+0xc>
    ;
  return os;
}
  87:	89 c8                	mov    %ecx,%eax
  89:	5b                   	pop    %ebx
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	53                   	push   %ebx
  90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 03             	movzbl (%ebx),%eax
  99:	0f b6 0a             	movzbl (%edx),%ecx
  9c:	84 c0                	test   %al,%al
  9e:	75 10                	jne    b0 <strcmp+0x24>
  a0:	eb 1a                	jmp    bc <strcmp+0x30>
  a2:	66 90                	xchg   %ax,%ax
    p++, q++;
  a4:	43                   	inc    %ebx
  a5:	42                   	inc    %edx
  while(*p && *p == *q)
  a6:	0f b6 03             	movzbl (%ebx),%eax
  a9:	0f b6 0a             	movzbl (%edx),%ecx
  ac:	84 c0                	test   %al,%al
  ae:	74 0c                	je     bc <strcmp+0x30>
  b0:	38 c8                	cmp    %cl,%al
  b2:	74 f0                	je     a4 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  b4:	29 c8                	sub    %ecx,%eax
}
  b6:	5b                   	pop    %ebx
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    
  b9:	8d 76 00             	lea    0x0(%esi),%esi
  bc:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  be:	29 c8                	sub    %ecx,%eax
}
  c0:	5b                   	pop    %ebx
  c1:	5d                   	pop    %ebp
  c2:	c3                   	ret    
  c3:	90                   	nop

000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ca:	80 3a 00             	cmpb   $0x0,(%edx)
  cd:	74 15                	je     e4 <strlen+0x20>
  cf:	31 c0                	xor    %eax,%eax
  d1:	8d 76 00             	lea    0x0(%esi),%esi
  d4:	40                   	inc    %eax
  d5:	89 c1                	mov    %eax,%ecx
  d7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  db:	75 f7                	jne    d4 <strlen+0x10>
    ;
  return n;
}
  dd:	89 c8                	mov    %ecx,%eax
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e4:	31 c9                	xor    %ecx,%ecx
}
  e6:	89 c8                	mov    %ecx,%eax
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    
  ea:	66 90                	xchg   %ax,%ax

000000ec <memset>:

void*
memset(void *dst, int c, uint n)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	fc                   	cld    
  fa:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	5f                   	pop    %edi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    
 102:	66 90                	xchg   %ax,%ax

00000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 10d:	8a 10                	mov    (%eax),%dl
 10f:	84 d2                	test   %dl,%dl
 111:	75 0c                	jne    11f <strchr+0x1b>
 113:	eb 13                	jmp    128 <strchr+0x24>
 115:	8d 76 00             	lea    0x0(%esi),%esi
 118:	40                   	inc    %eax
 119:	8a 10                	mov    (%eax),%dl
 11b:	84 d2                	test   %dl,%dl
 11d:	74 09                	je     128 <strchr+0x24>
    if(*s == c)
 11f:	38 d1                	cmp    %dl,%cl
 121:	75 f5                	jne    118 <strchr+0x14>
      return (char*)s;
  return 0;
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    
 125:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 128:	31 c0                	xor    %eax,%eax
}
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	8b 75 08             	mov    0x8(%ebp),%esi
 138:	bb 01 00 00 00       	mov    $0x1,%ebx
 13d:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 13f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 142:	eb 20                	jmp    164 <gets+0x38>
    cc = read(0, &c, 1);
 144:	50                   	push   %eax
 145:	6a 01                	push   $0x1
 147:	57                   	push   %edi
 148:	6a 00                	push   $0x0
 14a:	e8 ea 00 00 00       	call   239 <read>
    if(cc < 1)
 14f:	83 c4 10             	add    $0x10,%esp
 152:	85 c0                	test   %eax,%eax
 154:	7e 16                	jle    16c <gets+0x40>
      break;
    buf[i++] = c;
 156:	8a 45 e7             	mov    -0x19(%ebp),%al
 159:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 15b:	46                   	inc    %esi
 15c:	3c 0a                	cmp    $0xa,%al
 15e:	74 0c                	je     16c <gets+0x40>
 160:	3c 0d                	cmp    $0xd,%al
 162:	74 08                	je     16c <gets+0x40>
  for(i=0; i+1 < max; ){
 164:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 167:	39 45 0c             	cmp    %eax,0xc(%ebp)
 16a:	7f d8                	jg     144 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 16c:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    
 17a:	66 90                	xchg   %ax,%ax

0000017c <stat>:

int
stat(const char *n, struct stat *st)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 181:	83 ec 08             	sub    $0x8,%esp
 184:	6a 00                	push   $0x0
 186:	ff 75 08             	pushl  0x8(%ebp)
 189:	e8 d3 00 00 00       	call   261 <open>
  if(fd < 0)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	85 c0                	test   %eax,%eax
 193:	78 27                	js     1bc <stat+0x40>
 195:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	ff 75 0c             	pushl  0xc(%ebp)
 19d:	50                   	push   %eax
 19e:	e8 d6 00 00 00       	call   279 <fstat>
 1a3:	89 c6                	mov    %eax,%esi
  close(fd);
 1a5:	89 1c 24             	mov    %ebx,(%esp)
 1a8:	e8 9c 00 00 00       	call   249 <close>
  return r;
 1ad:	83 c4 10             	add    $0x10,%esp
}
 1b0:	89 f0                	mov    %esi,%eax
 1b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b5:	5b                   	pop    %ebx
 1b6:	5e                   	pop    %esi
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1bc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1c1:	eb ed                	jmp    1b0 <stat+0x34>
 1c3:	90                   	nop

000001c4 <atoi>:

int
atoi(const char *s)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	53                   	push   %ebx
 1c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1cb:	0f be 01             	movsbl (%ecx),%eax
 1ce:	8d 50 d0             	lea    -0x30(%eax),%edx
 1d1:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1d4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1d9:	77 16                	ja     1f1 <atoi+0x2d>
 1db:	90                   	nop
    n = n*10 + *s++ - '0';
 1dc:	41                   	inc    %ecx
 1dd:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1e0:	01 d2                	add    %edx,%edx
 1e2:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1e6:	0f be 01             	movsbl (%ecx),%eax
 1e9:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1ec:	80 fb 09             	cmp    $0x9,%bl
 1ef:	76 eb                	jbe    1dc <atoi+0x18>
  return n;
}
 1f1:	89 d0                	mov    %edx,%eax
 1f3:	5b                   	pop    %ebx
 1f4:	5d                   	pop    %ebp
 1f5:	c3                   	ret    
 1f6:	66 90                	xchg   %ax,%ax

000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	57                   	push   %edi
 1fc:	56                   	push   %esi
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8b 75 0c             	mov    0xc(%ebp),%esi
 203:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 206:	85 d2                	test   %edx,%edx
 208:	7e 0b                	jle    215 <memmove+0x1d>
 20a:	01 c2                	add    %eax,%edx
  dst = vdst;
 20c:	89 c7                	mov    %eax,%edi
 20e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 210:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 211:	39 fa                	cmp    %edi,%edx
 213:	75 fb                	jne    210 <memmove+0x18>
  return vdst;
}
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    

00000219 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 219:	b8 01 00 00 00       	mov    $0x1,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	ret    

00000221 <exit>:
SYSCALL(exit)
 221:	b8 02 00 00 00       	mov    $0x2,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <wait>:
SYSCALL(wait)
 229:	b8 03 00 00 00       	mov    $0x3,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <pipe>:
SYSCALL(pipe)
 231:	b8 04 00 00 00       	mov    $0x4,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <read>:
SYSCALL(read)
 239:	b8 05 00 00 00       	mov    $0x5,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <write>:
SYSCALL(write)
 241:	b8 10 00 00 00       	mov    $0x10,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <close>:
SYSCALL(close)
 249:	b8 15 00 00 00       	mov    $0x15,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <kill>:
SYSCALL(kill)
 251:	b8 06 00 00 00       	mov    $0x6,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <exec>:
SYSCALL(exec)
 259:	b8 07 00 00 00       	mov    $0x7,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <open>:
SYSCALL(open)
 261:	b8 0f 00 00 00       	mov    $0xf,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <mknod>:
SYSCALL(mknod)
 269:	b8 11 00 00 00       	mov    $0x11,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <unlink>:
SYSCALL(unlink)
 271:	b8 12 00 00 00       	mov    $0x12,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <fstat>:
SYSCALL(fstat)
 279:	b8 08 00 00 00       	mov    $0x8,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <link>:
SYSCALL(link)
 281:	b8 13 00 00 00       	mov    $0x13,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <mkdir>:
SYSCALL(mkdir)
 289:	b8 14 00 00 00       	mov    $0x14,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <chdir>:
SYSCALL(chdir)
 291:	b8 09 00 00 00       	mov    $0x9,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <dup>:
SYSCALL(dup)
 299:	b8 0a 00 00 00       	mov    $0xa,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <getpid>:
SYSCALL(getpid)
 2a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <sbrk>:
SYSCALL(sbrk)
 2a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <sleep>:
SYSCALL(sleep)
 2b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <uptime>:
SYSCALL(uptime)
 2b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <settickets>:
SYSCALL(settickets)
 2c1:	b8 16 00 00 00       	mov    $0x16,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <getpinfo>:
SYSCALL(getpinfo)
 2c9:	b8 17 00 00 00       	mov    $0x17,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    
 2d1:	66 90                	xchg   %ax,%ax
 2d3:	90                   	nop

000002d4 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	57                   	push   %edi
 2d8:	56                   	push   %esi
 2d9:	53                   	push   %ebx
 2da:	83 ec 3c             	sub    $0x3c,%esp
 2dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2e0:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2e3:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2e8:	85 db                	test   %ebx,%ebx
 2ea:	74 04                	je     2f0 <printint+0x1c>
 2ec:	85 d2                	test   %edx,%edx
 2ee:	78 68                	js     358 <printint+0x84>
  neg = 0;
 2f0:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f7:	31 ff                	xor    %edi,%edi
 2f9:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2fc:	89 c8                	mov    %ecx,%eax
 2fe:	31 d2                	xor    %edx,%edx
 300:	f7 75 c4             	divl   -0x3c(%ebp)
 303:	89 fb                	mov    %edi,%ebx
 305:	8d 7f 01             	lea    0x1(%edi),%edi
 308:	8a 92 9c 06 00 00    	mov    0x69c(%edx),%dl
 30e:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 312:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 315:	89 c1                	mov    %eax,%ecx
 317:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 31a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 31d:	76 dd                	jbe    2fc <printint+0x28>
  if(neg)
 31f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 322:	85 c9                	test   %ecx,%ecx
 324:	74 09                	je     32f <printint+0x5b>
    buf[i++] = '-';
 326:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 32b:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 32d:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 32f:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 333:	8b 7d bc             	mov    -0x44(%ebp),%edi
 336:	eb 03                	jmp    33b <printint+0x67>
 338:	8a 13                	mov    (%ebx),%dl
 33a:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 33b:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 33e:	50                   	push   %eax
 33f:	6a 01                	push   $0x1
 341:	56                   	push   %esi
 342:	57                   	push   %edi
 343:	e8 f9 fe ff ff       	call   241 <write>
  while(--i >= 0)
 348:	83 c4 10             	add    $0x10,%esp
 34b:	39 de                	cmp    %ebx,%esi
 34d:	75 e9                	jne    338 <printint+0x64>
}
 34f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 352:	5b                   	pop    %ebx
 353:	5e                   	pop    %esi
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	90                   	nop
    x = -xx;
 358:	f7 d9                	neg    %ecx
 35a:	eb 9b                	jmp    2f7 <printint+0x23>

0000035c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 365:	8b 75 0c             	mov    0xc(%ebp),%esi
 368:	8a 1e                	mov    (%esi),%bl
 36a:	84 db                	test   %bl,%bl
 36c:	0f 84 a3 00 00 00    	je     415 <printf+0xb9>
 372:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 373:	8d 45 10             	lea    0x10(%ebp),%eax
 376:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 379:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 37b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 37e:	eb 29                	jmp    3a9 <printf+0x4d>
 380:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 383:	83 f8 25             	cmp    $0x25,%eax
 386:	0f 84 94 00 00 00    	je     420 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 38c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 38f:	50                   	push   %eax
 390:	6a 01                	push   $0x1
 392:	57                   	push   %edi
 393:	ff 75 08             	pushl  0x8(%ebp)
 396:	e8 a6 fe ff ff       	call   241 <write>
        putc(fd, c);
 39b:	83 c4 10             	add    $0x10,%esp
 39e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 3a1:	46                   	inc    %esi
 3a2:	8a 5e ff             	mov    -0x1(%esi),%bl
 3a5:	84 db                	test   %bl,%bl
 3a7:	74 6c                	je     415 <printf+0xb9>
    c = fmt[i] & 0xff;
 3a9:	0f be cb             	movsbl %bl,%ecx
 3ac:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3af:	85 d2                	test   %edx,%edx
 3b1:	74 cd                	je     380 <printf+0x24>
      }
    } else if(state == '%'){
 3b3:	83 fa 25             	cmp    $0x25,%edx
 3b6:	75 e9                	jne    3a1 <printf+0x45>
      if(c == 'd'){
 3b8:	83 f8 64             	cmp    $0x64,%eax
 3bb:	0f 84 97 00 00 00    	je     458 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3c1:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 3c7:	83 f9 70             	cmp    $0x70,%ecx
 3ca:	74 60                	je     42c <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3cc:	83 f8 73             	cmp    $0x73,%eax
 3cf:	0f 84 8f 00 00 00    	je     464 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3d5:	83 f8 63             	cmp    $0x63,%eax
 3d8:	0f 84 d6 00 00 00    	je     4b4 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3de:	83 f8 25             	cmp    $0x25,%eax
 3e1:	0f 84 c1 00 00 00    	je     4a8 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3eb:	50                   	push   %eax
 3ec:	6a 01                	push   $0x1
 3ee:	57                   	push   %edi
 3ef:	ff 75 08             	pushl  0x8(%ebp)
 3f2:	e8 4a fe ff ff       	call   241 <write>
        putc(fd, c);
 3f7:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 3fa:	83 c4 0c             	add    $0xc,%esp
 3fd:	6a 01                	push   $0x1
 3ff:	57                   	push   %edi
 400:	ff 75 08             	pushl  0x8(%ebp)
 403:	e8 39 fe ff ff       	call   241 <write>
        putc(fd, c);
 408:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 40b:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 40d:	46                   	inc    %esi
 40e:	8a 5e ff             	mov    -0x1(%esi),%bl
 411:	84 db                	test   %bl,%bl
 413:	75 94                	jne    3a9 <printf+0x4d>
    }
  }
}
 415:	8d 65 f4             	lea    -0xc(%ebp),%esp
 418:	5b                   	pop    %ebx
 419:	5e                   	pop    %esi
 41a:	5f                   	pop    %edi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 420:	ba 25 00 00 00       	mov    $0x25,%edx
 425:	e9 77 ff ff ff       	jmp    3a1 <printf+0x45>
 42a:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 42c:	83 ec 0c             	sub    $0xc,%esp
 42f:	6a 00                	push   $0x0
 431:	b9 10 00 00 00       	mov    $0x10,%ecx
 436:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 439:	8b 13                	mov    (%ebx),%edx
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	e8 91 fe ff ff       	call   2d4 <printint>
        ap++;
 443:	89 d8                	mov    %ebx,%eax
 445:	83 c0 04             	add    $0x4,%eax
 448:	89 45 d0             	mov    %eax,-0x30(%ebp)
 44b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 44e:	31 d2                	xor    %edx,%edx
        ap++;
 450:	e9 4c ff ff ff       	jmp    3a1 <printf+0x45>
 455:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 458:	83 ec 0c             	sub    $0xc,%esp
 45b:	6a 01                	push   $0x1
 45d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 462:	eb d2                	jmp    436 <printf+0xda>
        s = (char*)*ap;
 464:	8b 45 d0             	mov    -0x30(%ebp),%eax
 467:	8b 18                	mov    (%eax),%ebx
        ap++;
 469:	83 c0 04             	add    $0x4,%eax
 46c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 46f:	85 db                	test   %ebx,%ebx
 471:	74 65                	je     4d8 <printf+0x17c>
        while(*s != 0){
 473:	8a 03                	mov    (%ebx),%al
 475:	84 c0                	test   %al,%al
 477:	74 70                	je     4e9 <printf+0x18d>
 479:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 47c:	89 de                	mov    %ebx,%esi
 47e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 481:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 484:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 487:	50                   	push   %eax
 488:	6a 01                	push   $0x1
 48a:	57                   	push   %edi
 48b:	53                   	push   %ebx
 48c:	e8 b0 fd ff ff       	call   241 <write>
          s++;
 491:	46                   	inc    %esi
        while(*s != 0){
 492:	8a 06                	mov    (%esi),%al
 494:	83 c4 10             	add    $0x10,%esp
 497:	84 c0                	test   %al,%al
 499:	75 e9                	jne    484 <printf+0x128>
 49b:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 49e:	31 d2                	xor    %edx,%edx
 4a0:	e9 fc fe ff ff       	jmp    3a1 <printf+0x45>
 4a5:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 4a8:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4ab:	52                   	push   %edx
 4ac:	e9 4c ff ff ff       	jmp    3fd <printf+0xa1>
 4b1:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 4b4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4b7:	8b 03                	mov    (%ebx),%eax
 4b9:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4bc:	51                   	push   %ecx
 4bd:	6a 01                	push   $0x1
 4bf:	57                   	push   %edi
 4c0:	ff 75 08             	pushl  0x8(%ebp)
 4c3:	e8 79 fd ff ff       	call   241 <write>
        ap++;
 4c8:	83 c3 04             	add    $0x4,%ebx
 4cb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ce:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d1:	31 d2                	xor    %edx,%edx
 4d3:	e9 c9 fe ff ff       	jmp    3a1 <printf+0x45>
          s = "(null)";
 4d8:	bb 95 06 00 00       	mov    $0x695,%ebx
        while(*s != 0){
 4dd:	b0 28                	mov    $0x28,%al
 4df:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4e2:	89 de                	mov    %ebx,%esi
 4e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4e7:	eb 9b                	jmp    484 <printf+0x128>
      state = 0;
 4e9:	31 d2                	xor    %edx,%edx
 4eb:	e9 b1 fe ff ff       	jmp    3a1 <printf+0x45>

000004f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4f9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fc:	a1 40 09 00 00       	mov    0x940,%eax
 501:	8b 10                	mov    (%eax),%edx
 503:	39 c8                	cmp    %ecx,%eax
 505:	73 11                	jae    518 <free+0x28>
 507:	90                   	nop
 508:	39 d1                	cmp    %edx,%ecx
 50a:	72 14                	jb     520 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 50c:	39 d0                	cmp    %edx,%eax
 50e:	73 10                	jae    520 <free+0x30>
{
 510:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 512:	8b 10                	mov    (%eax),%edx
 514:	39 c8                	cmp    %ecx,%eax
 516:	72 f0                	jb     508 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 518:	39 d0                	cmp    %edx,%eax
 51a:	72 f4                	jb     510 <free+0x20>
 51c:	39 d1                	cmp    %edx,%ecx
 51e:	73 f0                	jae    510 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 520:	8b 73 fc             	mov    -0x4(%ebx),%esi
 523:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 526:	39 fa                	cmp    %edi,%edx
 528:	74 1a                	je     544 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 52a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 52d:	8b 50 04             	mov    0x4(%eax),%edx
 530:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 533:	39 f1                	cmp    %esi,%ecx
 535:	74 24                	je     55b <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 537:	89 08                	mov    %ecx,(%eax)
  freep = p;
 539:	a3 40 09 00 00       	mov    %eax,0x940
}
 53e:	5b                   	pop    %ebx
 53f:	5e                   	pop    %esi
 540:	5f                   	pop    %edi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
 543:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 544:	03 72 04             	add    0x4(%edx),%esi
 547:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54a:	8b 10                	mov    (%eax),%edx
 54c:	8b 12                	mov    (%edx),%edx
 54e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 551:	8b 50 04             	mov    0x4(%eax),%edx
 554:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 557:	39 f1                	cmp    %esi,%ecx
 559:	75 dc                	jne    537 <free+0x47>
    p->s.size += bp->s.size;
 55b:	03 53 fc             	add    -0x4(%ebx),%edx
 55e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 561:	8b 53 f8             	mov    -0x8(%ebx),%edx
 564:	89 10                	mov    %edx,(%eax)
  freep = p;
 566:	a3 40 09 00 00       	mov    %eax,0x940
}
 56b:	5b                   	pop    %ebx
 56c:	5e                   	pop    %esi
 56d:	5f                   	pop    %edi
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    

00000570 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	8d 70 07             	lea    0x7(%eax),%esi
 57f:	c1 ee 03             	shr    $0x3,%esi
 582:	46                   	inc    %esi
  if((prevp = freep) == 0){
 583:	8b 3d 40 09 00 00    	mov    0x940,%edi
 589:	85 ff                	test   %edi,%edi
 58b:	0f 84 a3 00 00 00    	je     634 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 591:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 593:	8b 48 04             	mov    0x4(%eax),%ecx
 596:	39 f1                	cmp    %esi,%ecx
 598:	73 67                	jae    601 <malloc+0x91>
 59a:	89 f3                	mov    %esi,%ebx
 59c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 5a2:	0f 82 80 00 00 00    	jb     628 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 5a8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 5af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 5b2:	eb 11                	jmp    5c5 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b4:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 5b6:	8b 4a 04             	mov    0x4(%edx),%ecx
 5b9:	39 f1                	cmp    %esi,%ecx
 5bb:	73 4b                	jae    608 <malloc+0x98>
 5bd:	8b 3d 40 09 00 00    	mov    0x940,%edi
 5c3:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 5c5:	39 c7                	cmp    %eax,%edi
 5c7:	75 eb                	jne    5b4 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5c9:	83 ec 0c             	sub    $0xc,%esp
 5cc:	ff 75 e4             	pushl  -0x1c(%ebp)
 5cf:	e8 d5 fc ff ff       	call   2a9 <sbrk>
  if(p == (char*)-1)
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5da:	74 1b                	je     5f7 <malloc+0x87>
  hp->s.size = nu;
 5dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5df:	83 ec 0c             	sub    $0xc,%esp
 5e2:	83 c0 08             	add    $0x8,%eax
 5e5:	50                   	push   %eax
 5e6:	e8 05 ff ff ff       	call   4f0 <free>
  return freep;
 5eb:	a1 40 09 00 00       	mov    0x940,%eax
      if((p = morecore(nunits)) == 0)
 5f0:	83 c4 10             	add    $0x10,%esp
 5f3:	85 c0                	test   %eax,%eax
 5f5:	75 bd                	jne    5b4 <malloc+0x44>
        return 0;
 5f7:	31 c0                	xor    %eax,%eax
  }
}
 5f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5fc:	5b                   	pop    %ebx
 5fd:	5e                   	pop    %esi
 5fe:	5f                   	pop    %edi
 5ff:	5d                   	pop    %ebp
 600:	c3                   	ret    
    if(p->s.size >= nunits){
 601:	89 c2                	mov    %eax,%edx
 603:	89 f8                	mov    %edi,%eax
 605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 608:	39 ce                	cmp    %ecx,%esi
 60a:	74 54                	je     660 <malloc+0xf0>
        p->s.size -= nunits;
 60c:	29 f1                	sub    %esi,%ecx
 60e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 611:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 614:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 617:	a3 40 09 00 00       	mov    %eax,0x940
      return (void*)(p + 1);
 61c:	8d 42 08             	lea    0x8(%edx),%eax
}
 61f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 622:	5b                   	pop    %ebx
 623:	5e                   	pop    %esi
 624:	5f                   	pop    %edi
 625:	5d                   	pop    %ebp
 626:	c3                   	ret    
 627:	90                   	nop
 628:	bb 00 10 00 00       	mov    $0x1000,%ebx
 62d:	e9 76 ff ff ff       	jmp    5a8 <malloc+0x38>
 632:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 634:	c7 05 40 09 00 00 44 	movl   $0x944,0x940
 63b:	09 00 00 
 63e:	c7 05 44 09 00 00 44 	movl   $0x944,0x944
 645:	09 00 00 
    base.s.size = 0;
 648:	c7 05 48 09 00 00 00 	movl   $0x0,0x948
 64f:	00 00 00 
 652:	bf 44 09 00 00       	mov    $0x944,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 657:	89 f8                	mov    %edi,%eax
 659:	e9 3c ff ff ff       	jmp    59a <malloc+0x2a>
 65e:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 660:	8b 0a                	mov    (%edx),%ecx
 662:	89 08                	mov    %ecx,(%eax)
 664:	eb b1                	jmp    617 <malloc+0xa7>
