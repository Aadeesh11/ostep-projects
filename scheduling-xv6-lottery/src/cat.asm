
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 54                	jle    73 <main+0x73>
  1f:	83 c3 04             	add    $0x4,%ebx
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	pushl  (%ebx)
  2f:	e8 ad 02 00 00       	call   2e1 <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 22                	js     5f <main+0x5f>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	50                   	push   %eax
  41:	e8 3e 00 00 00       	call   84 <cat>
    close(fd);
  46:	89 3c 24             	mov    %edi,(%esp)
  49:	e8 7b 02 00 00       	call   2c9 <close>
  for(i = 1; i < argc; i++){
  4e:	46                   	inc    %esi
  4f:	83 c3 04             	add    $0x4,%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  58:	75 ce                	jne    28 <main+0x28>
  }
  exit();
  5a:	e8 42 02 00 00       	call   2a1 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5f:	50                   	push   %eax
  60:	ff 33                	pushl  (%ebx)
  62:	68 0b 07 00 00       	push   $0x70b
  67:	6a 01                	push   $0x1
  69:	e8 6e 03 00 00       	call   3dc <printf>
      exit();
  6e:	e8 2e 02 00 00       	call   2a1 <exit>
    cat(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 07 00 00 00       	call   84 <cat>
    exit();
  7d:	e8 1f 02 00 00       	call   2a1 <exit>
  82:	66 90                	xchg   %ax,%ax

00000084 <cat>:
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	56                   	push   %esi
  88:	53                   	push   %ebx
  89:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  8c:	eb 17                	jmp    a5 <cat+0x21>
  8e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  90:	51                   	push   %ecx
  91:	53                   	push   %ebx
  92:	68 20 0a 00 00       	push   $0xa20
  97:	6a 01                	push   $0x1
  99:	e8 23 02 00 00       	call   2c1 <write>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	39 d8                	cmp    %ebx,%eax
  a3:	75 23                	jne    c8 <cat+0x44>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  a5:	52                   	push   %edx
  a6:	68 00 02 00 00       	push   $0x200
  ab:	68 20 0a 00 00       	push   $0xa20
  b0:	56                   	push   %esi
  b1:	e8 03 02 00 00       	call   2b9 <read>
  b6:	89 c3                	mov    %eax,%ebx
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	85 c0                	test   %eax,%eax
  bd:	7f d1                	jg     90 <cat+0xc>
  if(n < 0){
  bf:	75 1b                	jne    dc <cat+0x58>
}
  c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
      printf(1, "cat: write error\n");
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	68 e8 06 00 00       	push   $0x6e8
  d0:	6a 01                	push   $0x1
  d2:	e8 05 03 00 00       	call   3dc <printf>
      exit();
  d7:	e8 c5 01 00 00       	call   2a1 <exit>
    printf(1, "cat: read error\n");
  dc:	50                   	push   %eax
  dd:	50                   	push   %eax
  de:	68 fa 06 00 00       	push   $0x6fa
  e3:	6a 01                	push   $0x1
  e5:	e8 f2 02 00 00       	call   3dc <printf>
    exit();
  ea:	e8 b2 01 00 00       	call   2a1 <exit>
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	31 c0                	xor    %eax,%eax
  fc:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 102:	40                   	inc    %eax
 103:	84 d2                	test   %dl,%dl
 105:	75 f5                	jne    fc <strcpy+0xc>
    ;
  return os;
}
 107:	89 c8                	mov    %ecx,%eax
 109:	5b                   	pop    %ebx
 10a:	5d                   	pop    %ebp
 10b:	c3                   	ret    

0000010c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
 10f:	53                   	push   %ebx
 110:	8b 5d 08             	mov    0x8(%ebp),%ebx
 113:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 116:	0f b6 03             	movzbl (%ebx),%eax
 119:	0f b6 0a             	movzbl (%edx),%ecx
 11c:	84 c0                	test   %al,%al
 11e:	75 10                	jne    130 <strcmp+0x24>
 120:	eb 1a                	jmp    13c <strcmp+0x30>
 122:	66 90                	xchg   %ax,%ax
    p++, q++;
 124:	43                   	inc    %ebx
 125:	42                   	inc    %edx
  while(*p && *p == *q)
 126:	0f b6 03             	movzbl (%ebx),%eax
 129:	0f b6 0a             	movzbl (%edx),%ecx
 12c:	84 c0                	test   %al,%al
 12e:	74 0c                	je     13c <strcmp+0x30>
 130:	38 c8                	cmp    %cl,%al
 132:	74 f0                	je     124 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 134:	29 c8                	sub    %ecx,%eax
}
 136:	5b                   	pop    %ebx
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    
 139:	8d 76 00             	lea    0x0(%esi),%esi
 13c:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 13e:	29 c8                	sub    %ecx,%eax
}
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	90                   	nop

00000144 <strlen>:

uint
strlen(const char *s)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 14a:	80 3a 00             	cmpb   $0x0,(%edx)
 14d:	74 15                	je     164 <strlen+0x20>
 14f:	31 c0                	xor    %eax,%eax
 151:	8d 76 00             	lea    0x0(%esi),%esi
 154:	40                   	inc    %eax
 155:	89 c1                	mov    %eax,%ecx
 157:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 15b:	75 f7                	jne    154 <strlen+0x10>
    ;
  return n;
}
 15d:	89 c8                	mov    %ecx,%eax
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 164:	31 c9                	xor    %ecx,%ecx
}
 166:	89 c8                	mov    %ecx,%eax
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    
 16a:	66 90                	xchg   %ax,%ax

0000016c <memset>:

void*
memset(void *dst, int c, uint n)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 170:	8b 7d 08             	mov    0x8(%ebp),%edi
 173:	8b 4d 10             	mov    0x10(%ebp),%ecx
 176:	8b 45 0c             	mov    0xc(%ebp),%eax
 179:	fc                   	cld    
 17a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	5f                   	pop    %edi
 180:	5d                   	pop    %ebp
 181:	c3                   	ret    
 182:	66 90                	xchg   %ax,%ax

00000184 <strchr>:

char*
strchr(const char *s, char c)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 18d:	8a 10                	mov    (%eax),%dl
 18f:	84 d2                	test   %dl,%dl
 191:	75 0c                	jne    19f <strchr+0x1b>
 193:	eb 13                	jmp    1a8 <strchr+0x24>
 195:	8d 76 00             	lea    0x0(%esi),%esi
 198:	40                   	inc    %eax
 199:	8a 10                	mov    (%eax),%dl
 19b:	84 d2                	test   %dl,%dl
 19d:	74 09                	je     1a8 <strchr+0x24>
    if(*s == c)
 19f:	38 d1                	cmp    %dl,%cl
 1a1:	75 f5                	jne    198 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1a8:	31 c0                	xor    %eax,%eax
}
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    

000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	56                   	push   %esi
 1b1:	53                   	push   %ebx
 1b2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	8b 75 08             	mov    0x8(%ebp),%esi
 1b8:	bb 01 00 00 00       	mov    $0x1,%ebx
 1bd:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 1bf:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1c2:	eb 20                	jmp    1e4 <gets+0x38>
    cc = read(0, &c, 1);
 1c4:	50                   	push   %eax
 1c5:	6a 01                	push   $0x1
 1c7:	57                   	push   %edi
 1c8:	6a 00                	push   $0x0
 1ca:	e8 ea 00 00 00       	call   2b9 <read>
    if(cc < 1)
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	85 c0                	test   %eax,%eax
 1d4:	7e 16                	jle    1ec <gets+0x40>
      break;
    buf[i++] = c;
 1d6:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d9:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 1db:	46                   	inc    %esi
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 0c                	je     1ec <gets+0x40>
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 08                	je     1ec <gets+0x40>
  for(i=0; i+1 < max; ){
 1e4:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 1e7:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1ea:	7f d8                	jg     1c4 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 1ec:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f5:	5b                   	pop    %ebx
 1f6:	5e                   	pop    %esi
 1f7:	5f                   	pop    %edi
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	66 90                	xchg   %ax,%ax

000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	56                   	push   %esi
 200:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	6a 00                	push   $0x0
 206:	ff 75 08             	pushl  0x8(%ebp)
 209:	e8 d3 00 00 00       	call   2e1 <open>
  if(fd < 0)
 20e:	83 c4 10             	add    $0x10,%esp
 211:	85 c0                	test   %eax,%eax
 213:	78 27                	js     23c <stat+0x40>
 215:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	ff 75 0c             	pushl  0xc(%ebp)
 21d:	50                   	push   %eax
 21e:	e8 d6 00 00 00       	call   2f9 <fstat>
 223:	89 c6                	mov    %eax,%esi
  close(fd);
 225:	89 1c 24             	mov    %ebx,(%esp)
 228:	e8 9c 00 00 00       	call   2c9 <close>
  return r;
 22d:	83 c4 10             	add    $0x10,%esp
}
 230:	89 f0                	mov    %esi,%eax
 232:	8d 65 f8             	lea    -0x8(%ebp),%esp
 235:	5b                   	pop    %ebx
 236:	5e                   	pop    %esi
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    
 239:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 23c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 241:	eb ed                	jmp    230 <stat+0x34>
 243:	90                   	nop

00000244 <atoi>:

int
atoi(const char *s)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	53                   	push   %ebx
 248:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24b:	0f be 01             	movsbl (%ecx),%eax
 24e:	8d 50 d0             	lea    -0x30(%eax),%edx
 251:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 254:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 259:	77 16                	ja     271 <atoi+0x2d>
 25b:	90                   	nop
    n = n*10 + *s++ - '0';
 25c:	41                   	inc    %ecx
 25d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 260:	01 d2                	add    %edx,%edx
 262:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 266:	0f be 01             	movsbl (%ecx),%eax
 269:	8d 58 d0             	lea    -0x30(%eax),%ebx
 26c:	80 fb 09             	cmp    $0x9,%bl
 26f:	76 eb                	jbe    25c <atoi+0x18>
  return n;
}
 271:	89 d0                	mov    %edx,%eax
 273:	5b                   	pop    %ebx
 274:	5d                   	pop    %ebp
 275:	c3                   	ret    
 276:	66 90                	xchg   %ax,%ax

00000278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	57                   	push   %edi
 27c:	56                   	push   %esi
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	8b 75 0c             	mov    0xc(%ebp),%esi
 283:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 286:	85 d2                	test   %edx,%edx
 288:	7e 0b                	jle    295 <memmove+0x1d>
 28a:	01 c2                	add    %eax,%edx
  dst = vdst;
 28c:	89 c7                	mov    %eax,%edi
 28e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 290:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 291:	39 fa                	cmp    %edi,%edx
 293:	75 fb                	jne    290 <memmove+0x18>
  return vdst;
}
 295:	5e                   	pop    %esi
 296:	5f                   	pop    %edi
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    

00000299 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 299:	b8 01 00 00 00       	mov    $0x1,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <exit>:
SYSCALL(exit)
 2a1:	b8 02 00 00 00       	mov    $0x2,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <wait>:
SYSCALL(wait)
 2a9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <pipe>:
SYSCALL(pipe)
 2b1:	b8 04 00 00 00       	mov    $0x4,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <read>:
SYSCALL(read)
 2b9:	b8 05 00 00 00       	mov    $0x5,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <write>:
SYSCALL(write)
 2c1:	b8 10 00 00 00       	mov    $0x10,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <close>:
SYSCALL(close)
 2c9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <kill>:
SYSCALL(kill)
 2d1:	b8 06 00 00 00       	mov    $0x6,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <exec>:
SYSCALL(exec)
 2d9:	b8 07 00 00 00       	mov    $0x7,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <open>:
SYSCALL(open)
 2e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <mknod>:
SYSCALL(mknod)
 2e9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <unlink>:
SYSCALL(unlink)
 2f1:	b8 12 00 00 00       	mov    $0x12,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <fstat>:
SYSCALL(fstat)
 2f9:	b8 08 00 00 00       	mov    $0x8,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <link>:
SYSCALL(link)
 301:	b8 13 00 00 00       	mov    $0x13,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <mkdir>:
SYSCALL(mkdir)
 309:	b8 14 00 00 00       	mov    $0x14,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <chdir>:
SYSCALL(chdir)
 311:	b8 09 00 00 00       	mov    $0x9,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <dup>:
SYSCALL(dup)
 319:	b8 0a 00 00 00       	mov    $0xa,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <getpid>:
SYSCALL(getpid)
 321:	b8 0b 00 00 00       	mov    $0xb,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <sbrk>:
SYSCALL(sbrk)
 329:	b8 0c 00 00 00       	mov    $0xc,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <sleep>:
SYSCALL(sleep)
 331:	b8 0d 00 00 00       	mov    $0xd,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <uptime>:
SYSCALL(uptime)
 339:	b8 0e 00 00 00       	mov    $0xe,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <settickets>:
SYSCALL(settickets)
 341:	b8 16 00 00 00       	mov    $0x16,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpinfo>:
SYSCALL(getpinfo)
 349:	b8 17 00 00 00       	mov    $0x17,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    
 351:	66 90                	xchg   %ax,%ax
 353:	90                   	nop

00000354 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	57                   	push   %edi
 358:	56                   	push   %esi
 359:	53                   	push   %ebx
 35a:	83 ec 3c             	sub    $0x3c,%esp
 35d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 360:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 363:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 365:	8b 5d 08             	mov    0x8(%ebp),%ebx
 368:	85 db                	test   %ebx,%ebx
 36a:	74 04                	je     370 <printint+0x1c>
 36c:	85 d2                	test   %edx,%edx
 36e:	78 68                	js     3d8 <printint+0x84>
  neg = 0;
 370:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 377:	31 ff                	xor    %edi,%edi
 379:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 37c:	89 c8                	mov    %ecx,%eax
 37e:	31 d2                	xor    %edx,%edx
 380:	f7 75 c4             	divl   -0x3c(%ebp)
 383:	89 fb                	mov    %edi,%ebx
 385:	8d 7f 01             	lea    0x1(%edi),%edi
 388:	8a 92 28 07 00 00    	mov    0x728(%edx),%dl
 38e:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 392:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 395:	89 c1                	mov    %eax,%ecx
 397:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 39a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 39d:	76 dd                	jbe    37c <printint+0x28>
  if(neg)
 39f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a2:	85 c9                	test   %ecx,%ecx
 3a4:	74 09                	je     3af <printint+0x5b>
    buf[i++] = '-';
 3a6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 3ab:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3ad:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 3af:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3b3:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3b6:	eb 03                	jmp    3bb <printint+0x67>
 3b8:	8a 13                	mov    (%ebx),%dl
 3ba:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 3bb:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3be:	50                   	push   %eax
 3bf:	6a 01                	push   $0x1
 3c1:	56                   	push   %esi
 3c2:	57                   	push   %edi
 3c3:	e8 f9 fe ff ff       	call   2c1 <write>
  while(--i >= 0)
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	39 de                	cmp    %ebx,%esi
 3cd:	75 e9                	jne    3b8 <printint+0x64>
}
 3cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d2:	5b                   	pop    %ebx
 3d3:	5e                   	pop    %esi
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    
 3d7:	90                   	nop
    x = -xx;
 3d8:	f7 d9                	neg    %ecx
 3da:	eb 9b                	jmp    377 <printint+0x23>

000003dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	57                   	push   %edi
 3e0:	56                   	push   %esi
 3e1:	53                   	push   %ebx
 3e2:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e5:	8b 75 0c             	mov    0xc(%ebp),%esi
 3e8:	8a 1e                	mov    (%esi),%bl
 3ea:	84 db                	test   %bl,%bl
 3ec:	0f 84 a3 00 00 00    	je     495 <printf+0xb9>
 3f2:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3f3:	8d 45 10             	lea    0x10(%ebp),%eax
 3f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 3f9:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 3fb:	8d 7d e7             	lea    -0x19(%ebp),%edi
 3fe:	eb 29                	jmp    429 <printf+0x4d>
 400:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 403:	83 f8 25             	cmp    $0x25,%eax
 406:	0f 84 94 00 00 00    	je     4a0 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 40c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 40f:	50                   	push   %eax
 410:	6a 01                	push   $0x1
 412:	57                   	push   %edi
 413:	ff 75 08             	pushl  0x8(%ebp)
 416:	e8 a6 fe ff ff       	call   2c1 <write>
        putc(fd, c);
 41b:	83 c4 10             	add    $0x10,%esp
 41e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 421:	46                   	inc    %esi
 422:	8a 5e ff             	mov    -0x1(%esi),%bl
 425:	84 db                	test   %bl,%bl
 427:	74 6c                	je     495 <printf+0xb9>
    c = fmt[i] & 0xff;
 429:	0f be cb             	movsbl %bl,%ecx
 42c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 42f:	85 d2                	test   %edx,%edx
 431:	74 cd                	je     400 <printf+0x24>
      }
    } else if(state == '%'){
 433:	83 fa 25             	cmp    $0x25,%edx
 436:	75 e9                	jne    421 <printf+0x45>
      if(c == 'd'){
 438:	83 f8 64             	cmp    $0x64,%eax
 43b:	0f 84 97 00 00 00    	je     4d8 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 441:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 447:	83 f9 70             	cmp    $0x70,%ecx
 44a:	74 60                	je     4ac <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 44c:	83 f8 73             	cmp    $0x73,%eax
 44f:	0f 84 8f 00 00 00    	je     4e4 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 455:	83 f8 63             	cmp    $0x63,%eax
 458:	0f 84 d6 00 00 00    	je     534 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 45e:	83 f8 25             	cmp    $0x25,%eax
 461:	0f 84 c1 00 00 00    	je     528 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 467:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 46b:	50                   	push   %eax
 46c:	6a 01                	push   $0x1
 46e:	57                   	push   %edi
 46f:	ff 75 08             	pushl  0x8(%ebp)
 472:	e8 4a fe ff ff       	call   2c1 <write>
        putc(fd, c);
 477:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 47a:	83 c4 0c             	add    $0xc,%esp
 47d:	6a 01                	push   $0x1
 47f:	57                   	push   %edi
 480:	ff 75 08             	pushl  0x8(%ebp)
 483:	e8 39 fe ff ff       	call   2c1 <write>
        putc(fd, c);
 488:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 48b:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 48d:	46                   	inc    %esi
 48e:	8a 5e ff             	mov    -0x1(%esi),%bl
 491:	84 db                	test   %bl,%bl
 493:	75 94                	jne    429 <printf+0x4d>
    }
  }
}
 495:	8d 65 f4             	lea    -0xc(%ebp),%esp
 498:	5b                   	pop    %ebx
 499:	5e                   	pop    %esi
 49a:	5f                   	pop    %edi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    
 49d:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 4a0:	ba 25 00 00 00       	mov    $0x25,%edx
 4a5:	e9 77 ff ff ff       	jmp    421 <printf+0x45>
 4aa:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4ac:	83 ec 0c             	sub    $0xc,%esp
 4af:	6a 00                	push   $0x0
 4b1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4b9:	8b 13                	mov    (%ebx),%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	e8 91 fe ff ff       	call   354 <printint>
        ap++;
 4c3:	89 d8                	mov    %ebx,%eax
 4c5:	83 c0 04             	add    $0x4,%eax
 4c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4cb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ce:	31 d2                	xor    %edx,%edx
        ap++;
 4d0:	e9 4c ff ff ff       	jmp    421 <printf+0x45>
 4d5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4d8:	83 ec 0c             	sub    $0xc,%esp
 4db:	6a 01                	push   $0x1
 4dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4e2:	eb d2                	jmp    4b6 <printf+0xda>
        s = (char*)*ap;
 4e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4e7:	8b 18                	mov    (%eax),%ebx
        ap++;
 4e9:	83 c0 04             	add    $0x4,%eax
 4ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4ef:	85 db                	test   %ebx,%ebx
 4f1:	74 65                	je     558 <printf+0x17c>
        while(*s != 0){
 4f3:	8a 03                	mov    (%ebx),%al
 4f5:	84 c0                	test   %al,%al
 4f7:	74 70                	je     569 <printf+0x18d>
 4f9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4fc:	89 de                	mov    %ebx,%esi
 4fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
 501:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 504:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 507:	50                   	push   %eax
 508:	6a 01                	push   $0x1
 50a:	57                   	push   %edi
 50b:	53                   	push   %ebx
 50c:	e8 b0 fd ff ff       	call   2c1 <write>
          s++;
 511:	46                   	inc    %esi
        while(*s != 0){
 512:	8a 06                	mov    (%esi),%al
 514:	83 c4 10             	add    $0x10,%esp
 517:	84 c0                	test   %al,%al
 519:	75 e9                	jne    504 <printf+0x128>
 51b:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 51e:	31 d2                	xor    %edx,%edx
 520:	e9 fc fe ff ff       	jmp    421 <printf+0x45>
 525:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 528:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 52b:	52                   	push   %edx
 52c:	e9 4c ff ff ff       	jmp    47d <printf+0xa1>
 531:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 534:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 537:	8b 03                	mov    (%ebx),%eax
 539:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 53c:	51                   	push   %ecx
 53d:	6a 01                	push   $0x1
 53f:	57                   	push   %edi
 540:	ff 75 08             	pushl  0x8(%ebp)
 543:	e8 79 fd ff ff       	call   2c1 <write>
        ap++;
 548:	83 c3 04             	add    $0x4,%ebx
 54b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 54e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 551:	31 d2                	xor    %edx,%edx
 553:	e9 c9 fe ff ff       	jmp    421 <printf+0x45>
          s = "(null)";
 558:	bb 20 07 00 00       	mov    $0x720,%ebx
        while(*s != 0){
 55d:	b0 28                	mov    $0x28,%al
 55f:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 562:	89 de                	mov    %ebx,%esi
 564:	8b 5d 08             	mov    0x8(%ebp),%ebx
 567:	eb 9b                	jmp    504 <printf+0x128>
      state = 0;
 569:	31 d2                	xor    %edx,%edx
 56b:	e9 b1 fe ff ff       	jmp    421 <printf+0x45>

00000570 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 579:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 57c:	a1 00 0a 00 00       	mov    0xa00,%eax
 581:	8b 10                	mov    (%eax),%edx
 583:	39 c8                	cmp    %ecx,%eax
 585:	73 11                	jae    598 <free+0x28>
 587:	90                   	nop
 588:	39 d1                	cmp    %edx,%ecx
 58a:	72 14                	jb     5a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58c:	39 d0                	cmp    %edx,%eax
 58e:	73 10                	jae    5a0 <free+0x30>
{
 590:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 592:	8b 10                	mov    (%eax),%edx
 594:	39 c8                	cmp    %ecx,%eax
 596:	72 f0                	jb     588 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 598:	39 d0                	cmp    %edx,%eax
 59a:	72 f4                	jb     590 <free+0x20>
 59c:	39 d1                	cmp    %edx,%ecx
 59e:	73 f0                	jae    590 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5a6:	39 fa                	cmp    %edi,%edx
 5a8:	74 1a                	je     5c4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ad:	8b 50 04             	mov    0x4(%eax),%edx
 5b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b3:	39 f1                	cmp    %esi,%ecx
 5b5:	74 24                	je     5db <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5b7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5b9:	a3 00 0a 00 00       	mov    %eax,0xa00
}
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
 5c3:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 5c4:	03 72 04             	add    0x4(%edx),%esi
 5c7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ca:	8b 10                	mov    (%eax),%edx
 5cc:	8b 12                	mov    (%edx),%edx
 5ce:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d1:	8b 50 04             	mov    0x4(%eax),%edx
 5d4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d7:	39 f1                	cmp    %esi,%ecx
 5d9:	75 dc                	jne    5b7 <free+0x47>
    p->s.size += bp->s.size;
 5db:	03 53 fc             	add    -0x4(%ebx),%edx
 5de:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5e1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 5e6:	a3 00 0a 00 00       	mov    %eax,0xa00
}
 5eb:	5b                   	pop    %ebx
 5ec:	5e                   	pop    %esi
 5ed:	5f                   	pop    %edi
 5ee:	5d                   	pop    %ebp
 5ef:	c3                   	ret    

000005f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	8d 70 07             	lea    0x7(%eax),%esi
 5ff:	c1 ee 03             	shr    $0x3,%esi
 602:	46                   	inc    %esi
  if((prevp = freep) == 0){
 603:	8b 3d 00 0a 00 00    	mov    0xa00,%edi
 609:	85 ff                	test   %edi,%edi
 60b:	0f 84 a3 00 00 00    	je     6b4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 611:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 613:	8b 48 04             	mov    0x4(%eax),%ecx
 616:	39 f1                	cmp    %esi,%ecx
 618:	73 67                	jae    681 <malloc+0x91>
 61a:	89 f3                	mov    %esi,%ebx
 61c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 622:	0f 82 80 00 00 00    	jb     6a8 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 628:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 62f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 632:	eb 11                	jmp    645 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 634:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 636:	8b 4a 04             	mov    0x4(%edx),%ecx
 639:	39 f1                	cmp    %esi,%ecx
 63b:	73 4b                	jae    688 <malloc+0x98>
 63d:	8b 3d 00 0a 00 00    	mov    0xa00,%edi
 643:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 645:	39 c7                	cmp    %eax,%edi
 647:	75 eb                	jne    634 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 649:	83 ec 0c             	sub    $0xc,%esp
 64c:	ff 75 e4             	pushl  -0x1c(%ebp)
 64f:	e8 d5 fc ff ff       	call   329 <sbrk>
  if(p == (char*)-1)
 654:	83 c4 10             	add    $0x10,%esp
 657:	83 f8 ff             	cmp    $0xffffffff,%eax
 65a:	74 1b                	je     677 <malloc+0x87>
  hp->s.size = nu;
 65c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 65f:	83 ec 0c             	sub    $0xc,%esp
 662:	83 c0 08             	add    $0x8,%eax
 665:	50                   	push   %eax
 666:	e8 05 ff ff ff       	call   570 <free>
  return freep;
 66b:	a1 00 0a 00 00       	mov    0xa00,%eax
      if((p = morecore(nunits)) == 0)
 670:	83 c4 10             	add    $0x10,%esp
 673:	85 c0                	test   %eax,%eax
 675:	75 bd                	jne    634 <malloc+0x44>
        return 0;
 677:	31 c0                	xor    %eax,%eax
  }
}
 679:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67c:	5b                   	pop    %ebx
 67d:	5e                   	pop    %esi
 67e:	5f                   	pop    %edi
 67f:	5d                   	pop    %ebp
 680:	c3                   	ret    
    if(p->s.size >= nunits){
 681:	89 c2                	mov    %eax,%edx
 683:	89 f8                	mov    %edi,%eax
 685:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 688:	39 ce                	cmp    %ecx,%esi
 68a:	74 54                	je     6e0 <malloc+0xf0>
        p->s.size -= nunits;
 68c:	29 f1                	sub    %esi,%ecx
 68e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 691:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 694:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 697:	a3 00 0a 00 00       	mov    %eax,0xa00
      return (void*)(p + 1);
 69c:	8d 42 08             	lea    0x8(%edx),%eax
}
 69f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a2:	5b                   	pop    %ebx
 6a3:	5e                   	pop    %esi
 6a4:	5f                   	pop    %edi
 6a5:	5d                   	pop    %ebp
 6a6:	c3                   	ret    
 6a7:	90                   	nop
 6a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6ad:	e9 76 ff ff ff       	jmp    628 <malloc+0x38>
 6b2:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6b4:	c7 05 00 0a 00 00 04 	movl   $0xa04,0xa00
 6bb:	0a 00 00 
 6be:	c7 05 04 0a 00 00 04 	movl   $0xa04,0xa04
 6c5:	0a 00 00 
    base.s.size = 0;
 6c8:	c7 05 08 0a 00 00 00 	movl   $0x0,0xa08
 6cf:	00 00 00 
 6d2:	bf 04 0a 00 00       	mov    $0xa04,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d7:	89 f8                	mov    %edi,%eax
 6d9:	e9 3c ff ff ff       	jmp    61a <malloc+0x2a>
 6de:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6e0:	8b 0a                	mov    (%edx),%ecx
 6e2:	89 08                	mov    %ecx,(%eax)
 6e4:	eb b1                	jmp    697 <malloc+0xa7>
