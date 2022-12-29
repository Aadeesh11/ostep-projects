
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
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
  1d:	7e 56                	jle    75 <main+0x75>
  1f:	83 c3 04             	add    $0x4,%ebx
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	pushl  (%ebx)
  2f:	e8 05 03 00 00       	call   339 <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 24                	js     61 <main+0x61>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	ff 33                	pushl  (%ebx)
  42:	50                   	push   %eax
  43:	e8 40 00 00 00       	call   88 <wc>
    close(fd);
  48:	89 3c 24             	mov    %edi,(%esp)
  4b:	e8 d1 02 00 00       	call   321 <close>
  for(i = 1; i < argc; i++){
  50:	46                   	inc    %esi
  51:	83 c3 04             	add    $0x4,%ebx
  54:	83 c4 10             	add    $0x10,%esp
  57:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  5a:	75 cc                	jne    28 <main+0x28>
  }
  exit();
  5c:	e8 98 02 00 00       	call   2f9 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  61:	50                   	push   %eax
  62:	ff 33                	pushl  (%ebx)
  64:	68 63 07 00 00       	push   $0x763
  69:	6a 01                	push   $0x1
  6b:	e8 c4 03 00 00       	call   434 <printf>
      exit();
  70:	e8 84 02 00 00       	call   2f9 <exit>
    wc(0, "");
  75:	52                   	push   %edx
  76:	52                   	push   %edx
  77:	68 55 07 00 00       	push   $0x755
  7c:	6a 00                	push   $0x0
  7e:	e8 05 00 00 00       	call   88 <wc>
    exit();
  83:	e8 71 02 00 00       	call   2f9 <exit>

00000088 <wc>:
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	57                   	push   %edi
  8c:	56                   	push   %esi
  8d:	53                   	push   %ebx
  8e:	83 ec 1c             	sub    $0x1c,%esp
  inword = 0;
  91:	31 f6                	xor    %esi,%esi
  l = w = c = 0;
  93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  a8:	52                   	push   %edx
  a9:	68 00 02 00 00       	push   $0x200
  ae:	68 80 0a 00 00       	push   $0xa80
  b3:	ff 75 08             	pushl  0x8(%ebp)
  b6:	e8 56 02 00 00       	call   311 <read>
  bb:	89 c3                	mov    %eax,%ebx
  bd:	83 c4 10             	add    $0x10,%esp
  c0:	85 c0                	test   %eax,%eax
  c2:	7e 48                	jle    10c <wc+0x84>
    for(i=0; i<n; i++){
  c4:	31 ff                	xor    %edi,%edi
  c6:	eb 07                	jmp    cf <wc+0x47>
        inword = 0;
  c8:	31 f6                	xor    %esi,%esi
    for(i=0; i<n; i++){
  ca:	47                   	inc    %edi
  cb:	39 fb                	cmp    %edi,%ebx
  cd:	74 35                	je     104 <wc+0x7c>
      if(buf[i] == '\n')
  cf:	0f be 87 80 0a 00 00 	movsbl 0xa80(%edi),%eax
  d6:	3c 0a                	cmp    $0xa,%al
  d8:	75 03                	jne    dd <wc+0x55>
        l++;
  da:	ff 45 e4             	incl   -0x1c(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  dd:	83 ec 08             	sub    $0x8,%esp
  e0:	50                   	push   %eax
  e1:	68 40 07 00 00       	push   $0x740
  e6:	e8 f1 00 00 00       	call   1dc <strchr>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	85 c0                	test   %eax,%eax
  f0:	75 d6                	jne    c8 <wc+0x40>
      else if(!inword){
  f2:	85 f6                	test   %esi,%esi
  f4:	75 d4                	jne    ca <wc+0x42>
        w++;
  f6:	ff 45 e0             	incl   -0x20(%ebp)
        inword = 1;
  f9:	be 01 00 00 00       	mov    $0x1,%esi
    for(i=0; i<n; i++){
  fe:	47                   	inc    %edi
  ff:	39 fb                	cmp    %edi,%ebx
 101:	75 cc                	jne    cf <wc+0x47>
 103:	90                   	nop
 104:	01 5d dc             	add    %ebx,-0x24(%ebp)
 107:	eb 9f                	jmp    a8 <wc+0x20>
 109:	8d 76 00             	lea    0x0(%esi),%esi
  if(n < 0){
 10c:	75 26                	jne    134 <wc+0xac>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	ff 75 0c             	pushl  0xc(%ebp)
 114:	ff 75 dc             	pushl  -0x24(%ebp)
 117:	ff 75 e0             	pushl  -0x20(%ebp)
 11a:	ff 75 e4             	pushl  -0x1c(%ebp)
 11d:	68 56 07 00 00       	push   $0x756
 122:	6a 01                	push   $0x1
 124:	e8 0b 03 00 00       	call   434 <printf>
}
 129:	83 c4 20             	add    $0x20,%esp
 12c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 12f:	5b                   	pop    %ebx
 130:	5e                   	pop    %esi
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
    printf(1, "wc: read error\n");
 134:	50                   	push   %eax
 135:	50                   	push   %eax
 136:	68 46 07 00 00       	push   $0x746
 13b:	6a 01                	push   $0x1
 13d:	e8 f2 02 00 00       	call   434 <printf>
    exit();
 142:	e8 b2 01 00 00       	call   2f9 <exit>
 147:	90                   	nop

00000148 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	53                   	push   %ebx
 14c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 152:	31 c0                	xor    %eax,%eax
 154:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 157:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 15a:	40                   	inc    %eax
 15b:	84 d2                	test   %dl,%dl
 15d:	75 f5                	jne    154 <strcpy+0xc>
    ;
  return os;
}
 15f:	89 c8                	mov    %ecx,%eax
 161:	5b                   	pop    %ebx
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	53                   	push   %ebx
 168:	8b 5d 08             	mov    0x8(%ebp),%ebx
 16b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16e:	0f b6 03             	movzbl (%ebx),%eax
 171:	0f b6 0a             	movzbl (%edx),%ecx
 174:	84 c0                	test   %al,%al
 176:	75 10                	jne    188 <strcmp+0x24>
 178:	eb 1a                	jmp    194 <strcmp+0x30>
 17a:	66 90                	xchg   %ax,%ax
    p++, q++;
 17c:	43                   	inc    %ebx
 17d:	42                   	inc    %edx
  while(*p && *p == *q)
 17e:	0f b6 03             	movzbl (%ebx),%eax
 181:	0f b6 0a             	movzbl (%edx),%ecx
 184:	84 c0                	test   %al,%al
 186:	74 0c                	je     194 <strcmp+0x30>
 188:	38 c8                	cmp    %cl,%al
 18a:	74 f0                	je     17c <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 18c:	29 c8                	sub    %ecx,%eax
}
 18e:	5b                   	pop    %ebx
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi
 194:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 196:	29 c8                	sub    %ecx,%eax
}
 198:	5b                   	pop    %ebx
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
 19b:	90                   	nop

0000019c <strlen>:

uint
strlen(const char *s)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1a2:	80 3a 00             	cmpb   $0x0,(%edx)
 1a5:	74 15                	je     1bc <strlen+0x20>
 1a7:	31 c0                	xor    %eax,%eax
 1a9:	8d 76 00             	lea    0x0(%esi),%esi
 1ac:	40                   	inc    %eax
 1ad:	89 c1                	mov    %eax,%ecx
 1af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1b3:	75 f7                	jne    1ac <strlen+0x10>
    ;
  return n;
}
 1b5:	89 c8                	mov    %ecx,%eax
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 1bc:	31 c9                	xor    %ecx,%ecx
}
 1be:	89 c8                	mov    %ecx,%eax
 1c0:	5d                   	pop    %ebp
 1c1:	c3                   	ret    
 1c2:	66 90                	xchg   %ax,%ax

000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c8:	8b 7d 08             	mov    0x8(%ebp),%edi
 1cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	5f                   	pop    %edi
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    
 1da:	66 90                	xchg   %ax,%ax

000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1e5:	8a 10                	mov    (%eax),%dl
 1e7:	84 d2                	test   %dl,%dl
 1e9:	75 0c                	jne    1f7 <strchr+0x1b>
 1eb:	eb 13                	jmp    200 <strchr+0x24>
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	40                   	inc    %eax
 1f1:	8a 10                	mov    (%eax),%dl
 1f3:	84 d2                	test   %dl,%dl
 1f5:	74 09                	je     200 <strchr+0x24>
    if(*s == c)
 1f7:	38 d1                	cmp    %dl,%cl
 1f9:	75 f5                	jne    1f0 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    

00000204 <gets>:

char*
gets(char *buf, int max)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	56                   	push   %esi
 209:	53                   	push   %ebx
 20a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	8b 75 08             	mov    0x8(%ebp),%esi
 210:	bb 01 00 00 00       	mov    $0x1,%ebx
 215:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 217:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 21a:	eb 20                	jmp    23c <gets+0x38>
    cc = read(0, &c, 1);
 21c:	50                   	push   %eax
 21d:	6a 01                	push   $0x1
 21f:	57                   	push   %edi
 220:	6a 00                	push   $0x0
 222:	e8 ea 00 00 00       	call   311 <read>
    if(cc < 1)
 227:	83 c4 10             	add    $0x10,%esp
 22a:	85 c0                	test   %eax,%eax
 22c:	7e 16                	jle    244 <gets+0x40>
      break;
    buf[i++] = c;
 22e:	8a 45 e7             	mov    -0x19(%ebp),%al
 231:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 233:	46                   	inc    %esi
 234:	3c 0a                	cmp    $0xa,%al
 236:	74 0c                	je     244 <gets+0x40>
 238:	3c 0d                	cmp    $0xd,%al
 23a:	74 08                	je     244 <gets+0x40>
  for(i=0; i+1 < max; ){
 23c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 23f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 242:	7f d8                	jg     21c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 244:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24d:	5b                   	pop    %ebx
 24e:	5e                   	pop    %esi
 24f:	5f                   	pop    %edi
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    
 252:	66 90                	xchg   %ax,%ax

00000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	56                   	push   %esi
 258:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	6a 00                	push   $0x0
 25e:	ff 75 08             	pushl  0x8(%ebp)
 261:	e8 d3 00 00 00       	call   339 <open>
  if(fd < 0)
 266:	83 c4 10             	add    $0x10,%esp
 269:	85 c0                	test   %eax,%eax
 26b:	78 27                	js     294 <stat+0x40>
 26d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	ff 75 0c             	pushl  0xc(%ebp)
 275:	50                   	push   %eax
 276:	e8 d6 00 00 00       	call   351 <fstat>
 27b:	89 c6                	mov    %eax,%esi
  close(fd);
 27d:	89 1c 24             	mov    %ebx,(%esp)
 280:	e8 9c 00 00 00       	call   321 <close>
  return r;
 285:	83 c4 10             	add    $0x10,%esp
}
 288:	89 f0                	mov    %esi,%eax
 28a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 28d:	5b                   	pop    %ebx
 28e:	5e                   	pop    %esi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 294:	be ff ff ff ff       	mov    $0xffffffff,%esi
 299:	eb ed                	jmp    288 <stat+0x34>
 29b:	90                   	nop

0000029c <atoi>:

int
atoi(const char *s)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	53                   	push   %ebx
 2a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a3:	0f be 01             	movsbl (%ecx),%eax
 2a6:	8d 50 d0             	lea    -0x30(%eax),%edx
 2a9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 2ac:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2b1:	77 16                	ja     2c9 <atoi+0x2d>
 2b3:	90                   	nop
    n = n*10 + *s++ - '0';
 2b4:	41                   	inc    %ecx
 2b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 2b8:	01 d2                	add    %edx,%edx
 2ba:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 2be:	0f be 01             	movsbl (%ecx),%eax
 2c1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2c4:	80 fb 09             	cmp    $0x9,%bl
 2c7:	76 eb                	jbe    2b4 <atoi+0x18>
  return n;
}
 2c9:	89 d0                	mov    %edx,%eax
 2cb:	5b                   	pop    %ebx
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    
 2ce:	66 90                	xchg   %ax,%ax

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8b 75 0c             	mov    0xc(%ebp),%esi
 2db:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 d2                	test   %edx,%edx
 2e0:	7e 0b                	jle    2ed <memmove+0x1d>
 2e2:	01 c2                	add    %eax,%edx
  dst = vdst;
 2e4:	89 c7                	mov    %eax,%edi
 2e6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e9:	39 fa                	cmp    %edi,%edx
 2eb:	75 fb                	jne    2e8 <memmove+0x18>
  return vdst;
}
 2ed:	5e                   	pop    %esi
 2ee:	5f                   	pop    %edi
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    

000002f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f1:	b8 01 00 00 00       	mov    $0x1,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exit>:
SYSCALL(exit)
 2f9:	b8 02 00 00 00       	mov    $0x2,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <wait>:
SYSCALL(wait)
 301:	b8 03 00 00 00       	mov    $0x3,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <pipe>:
SYSCALL(pipe)
 309:	b8 04 00 00 00       	mov    $0x4,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <read>:
SYSCALL(read)
 311:	b8 05 00 00 00       	mov    $0x5,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <write>:
SYSCALL(write)
 319:	b8 10 00 00 00       	mov    $0x10,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <close>:
SYSCALL(close)
 321:	b8 15 00 00 00       	mov    $0x15,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <kill>:
SYSCALL(kill)
 329:	b8 06 00 00 00       	mov    $0x6,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <exec>:
SYSCALL(exec)
 331:	b8 07 00 00 00       	mov    $0x7,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <open>:
SYSCALL(open)
 339:	b8 0f 00 00 00       	mov    $0xf,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <mknod>:
SYSCALL(mknod)
 341:	b8 11 00 00 00       	mov    $0x11,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <unlink>:
SYSCALL(unlink)
 349:	b8 12 00 00 00       	mov    $0x12,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <fstat>:
SYSCALL(fstat)
 351:	b8 08 00 00 00       	mov    $0x8,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <link>:
SYSCALL(link)
 359:	b8 13 00 00 00       	mov    $0x13,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mkdir>:
SYSCALL(mkdir)
 361:	b8 14 00 00 00       	mov    $0x14,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <chdir>:
SYSCALL(chdir)
 369:	b8 09 00 00 00       	mov    $0x9,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <dup>:
SYSCALL(dup)
 371:	b8 0a 00 00 00       	mov    $0xa,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getpid>:
SYSCALL(getpid)
 379:	b8 0b 00 00 00       	mov    $0xb,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sbrk>:
SYSCALL(sbrk)
 381:	b8 0c 00 00 00       	mov    $0xc,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sleep>:
SYSCALL(sleep)
 389:	b8 0d 00 00 00       	mov    $0xd,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <uptime>:
SYSCALL(uptime)
 391:	b8 0e 00 00 00       	mov    $0xe,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <settickets>:
SYSCALL(settickets)
 399:	b8 16 00 00 00       	mov    $0x16,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <getpinfo>:
SYSCALL(getpinfo)
 3a1:	b8 17 00 00 00       	mov    $0x17,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    
 3a9:	66 90                	xchg   %ax,%ax
 3ab:	90                   	nop

000003ac <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 3c             	sub    $0x3c,%esp
 3b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 3b8:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3bb:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 3bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3c0:	85 db                	test   %ebx,%ebx
 3c2:	74 04                	je     3c8 <printint+0x1c>
 3c4:	85 d2                	test   %edx,%edx
 3c6:	78 68                	js     430 <printint+0x84>
  neg = 0;
 3c8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3cf:	31 ff                	xor    %edi,%edi
 3d1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 3d4:	89 c8                	mov    %ecx,%eax
 3d6:	31 d2                	xor    %edx,%edx
 3d8:	f7 75 c4             	divl   -0x3c(%ebp)
 3db:	89 fb                	mov    %edi,%ebx
 3dd:	8d 7f 01             	lea    0x1(%edi),%edi
 3e0:	8a 92 80 07 00 00    	mov    0x780(%edx),%dl
 3e6:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ea:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 3ed:	89 c1                	mov    %eax,%ecx
 3ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3f2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 3f5:	76 dd                	jbe    3d4 <printint+0x28>
  if(neg)
 3f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3fa:	85 c9                	test   %ecx,%ecx
 3fc:	74 09                	je     407 <printint+0x5b>
    buf[i++] = '-';
 3fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 403:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 405:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 407:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 40b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 40e:	eb 03                	jmp    413 <printint+0x67>
 410:	8a 13                	mov    (%ebx),%dl
 412:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 413:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 416:	50                   	push   %eax
 417:	6a 01                	push   $0x1
 419:	56                   	push   %esi
 41a:	57                   	push   %edi
 41b:	e8 f9 fe ff ff       	call   319 <write>
  while(--i >= 0)
 420:	83 c4 10             	add    $0x10,%esp
 423:	39 de                	cmp    %ebx,%esi
 425:	75 e9                	jne    410 <printint+0x64>
}
 427:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42a:	5b                   	pop    %ebx
 42b:	5e                   	pop    %esi
 42c:	5f                   	pop    %edi
 42d:	5d                   	pop    %ebp
 42e:	c3                   	ret    
 42f:	90                   	nop
    x = -xx;
 430:	f7 d9                	neg    %ecx
 432:	eb 9b                	jmp    3cf <printint+0x23>

00000434 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	56                   	push   %esi
 439:	53                   	push   %ebx
 43a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 43d:	8b 75 0c             	mov    0xc(%ebp),%esi
 440:	8a 1e                	mov    (%esi),%bl
 442:	84 db                	test   %bl,%bl
 444:	0f 84 a3 00 00 00    	je     4ed <printf+0xb9>
 44a:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 44b:	8d 45 10             	lea    0x10(%ebp),%eax
 44e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 451:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 453:	8d 7d e7             	lea    -0x19(%ebp),%edi
 456:	eb 29                	jmp    481 <printf+0x4d>
 458:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 45b:	83 f8 25             	cmp    $0x25,%eax
 45e:	0f 84 94 00 00 00    	je     4f8 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 464:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 467:	50                   	push   %eax
 468:	6a 01                	push   $0x1
 46a:	57                   	push   %edi
 46b:	ff 75 08             	pushl  0x8(%ebp)
 46e:	e8 a6 fe ff ff       	call   319 <write>
        putc(fd, c);
 473:	83 c4 10             	add    $0x10,%esp
 476:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 479:	46                   	inc    %esi
 47a:	8a 5e ff             	mov    -0x1(%esi),%bl
 47d:	84 db                	test   %bl,%bl
 47f:	74 6c                	je     4ed <printf+0xb9>
    c = fmt[i] & 0xff;
 481:	0f be cb             	movsbl %bl,%ecx
 484:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 487:	85 d2                	test   %edx,%edx
 489:	74 cd                	je     458 <printf+0x24>
      }
    } else if(state == '%'){
 48b:	83 fa 25             	cmp    $0x25,%edx
 48e:	75 e9                	jne    479 <printf+0x45>
      if(c == 'd'){
 490:	83 f8 64             	cmp    $0x64,%eax
 493:	0f 84 97 00 00 00    	je     530 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 499:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 49f:	83 f9 70             	cmp    $0x70,%ecx
 4a2:	74 60                	je     504 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a4:	83 f8 73             	cmp    $0x73,%eax
 4a7:	0f 84 8f 00 00 00    	je     53c <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ad:	83 f8 63             	cmp    $0x63,%eax
 4b0:	0f 84 d6 00 00 00    	je     58c <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b6:	83 f8 25             	cmp    $0x25,%eax
 4b9:	0f 84 c1 00 00 00    	je     580 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4c3:	50                   	push   %eax
 4c4:	6a 01                	push   $0x1
 4c6:	57                   	push   %edi
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 4a fe ff ff       	call   319 <write>
        putc(fd, c);
 4cf:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4d2:	83 c4 0c             	add    $0xc,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	57                   	push   %edi
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 39 fe ff ff       	call   319 <write>
        putc(fd, c);
 4e0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4e3:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4e5:	46                   	inc    %esi
 4e6:	8a 5e ff             	mov    -0x1(%esi),%bl
 4e9:	84 db                	test   %bl,%bl
 4eb:	75 94                	jne    481 <printf+0x4d>
    }
  }
}
 4ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 4f8:	ba 25 00 00 00       	mov    $0x25,%edx
 4fd:	e9 77 ff ff ff       	jmp    479 <printf+0x45>
 502:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 504:	83 ec 0c             	sub    $0xc,%esp
 507:	6a 00                	push   $0x0
 509:	b9 10 00 00 00       	mov    $0x10,%ecx
 50e:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 511:	8b 13                	mov    (%ebx),%edx
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	e8 91 fe ff ff       	call   3ac <printint>
        ap++;
 51b:	89 d8                	mov    %ebx,%eax
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d0             	mov    %eax,-0x30(%ebp)
 523:	83 c4 10             	add    $0x10,%esp
      state = 0;
 526:	31 d2                	xor    %edx,%edx
        ap++;
 528:	e9 4c ff ff ff       	jmp    479 <printf+0x45>
 52d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	6a 01                	push   $0x1
 535:	b9 0a 00 00 00       	mov    $0xa,%ecx
 53a:	eb d2                	jmp    50e <printf+0xda>
        s = (char*)*ap;
 53c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 53f:	8b 18                	mov    (%eax),%ebx
        ap++;
 541:	83 c0 04             	add    $0x4,%eax
 544:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 547:	85 db                	test   %ebx,%ebx
 549:	74 65                	je     5b0 <printf+0x17c>
        while(*s != 0){
 54b:	8a 03                	mov    (%ebx),%al
 54d:	84 c0                	test   %al,%al
 54f:	74 70                	je     5c1 <printf+0x18d>
 551:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 554:	89 de                	mov    %ebx,%esi
 556:	8b 5d 08             	mov    0x8(%ebp),%ebx
 559:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 55c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55f:	50                   	push   %eax
 560:	6a 01                	push   $0x1
 562:	57                   	push   %edi
 563:	53                   	push   %ebx
 564:	e8 b0 fd ff ff       	call   319 <write>
          s++;
 569:	46                   	inc    %esi
        while(*s != 0){
 56a:	8a 06                	mov    (%esi),%al
 56c:	83 c4 10             	add    $0x10,%esp
 56f:	84 c0                	test   %al,%al
 571:	75 e9                	jne    55c <printf+0x128>
 573:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 576:	31 d2                	xor    %edx,%edx
 578:	e9 fc fe ff ff       	jmp    479 <printf+0x45>
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 580:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 583:	52                   	push   %edx
 584:	e9 4c ff ff ff       	jmp    4d5 <printf+0xa1>
 589:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 58c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 58f:	8b 03                	mov    (%ebx),%eax
 591:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 594:	51                   	push   %ecx
 595:	6a 01                	push   $0x1
 597:	57                   	push   %edi
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 79 fd ff ff       	call   319 <write>
        ap++;
 5a0:	83 c3 04             	add    $0x4,%ebx
 5a3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5a6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a9:	31 d2                	xor    %edx,%edx
 5ab:	e9 c9 fe ff ff       	jmp    479 <printf+0x45>
          s = "(null)";
 5b0:	bb 77 07 00 00       	mov    $0x777,%ebx
        while(*s != 0){
 5b5:	b0 28                	mov    $0x28,%al
 5b7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5ba:	89 de                	mov    %ebx,%esi
 5bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5bf:	eb 9b                	jmp    55c <printf+0x128>
      state = 0;
 5c1:	31 d2                	xor    %edx,%edx
 5c3:	e9 b1 fe ff ff       	jmp    479 <printf+0x45>

000005c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	57                   	push   %edi
 5cc:	56                   	push   %esi
 5cd:	53                   	push   %ebx
 5ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d4:	a1 60 0a 00 00       	mov    0xa60,%eax
 5d9:	8b 10                	mov    (%eax),%edx
 5db:	39 c8                	cmp    %ecx,%eax
 5dd:	73 11                	jae    5f0 <free+0x28>
 5df:	90                   	nop
 5e0:	39 d1                	cmp    %edx,%ecx
 5e2:	72 14                	jb     5f8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e4:	39 d0                	cmp    %edx,%eax
 5e6:	73 10                	jae    5f8 <free+0x30>
{
 5e8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ea:	8b 10                	mov    (%eax),%edx
 5ec:	39 c8                	cmp    %ecx,%eax
 5ee:	72 f0                	jb     5e0 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	39 d0                	cmp    %edx,%eax
 5f2:	72 f4                	jb     5e8 <free+0x20>
 5f4:	39 d1                	cmp    %edx,%ecx
 5f6:	73 f0                	jae    5e8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fe:	39 fa                	cmp    %edi,%edx
 600:	74 1a                	je     61c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 602:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 605:	8b 50 04             	mov    0x4(%eax),%edx
 608:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60b:	39 f1                	cmp    %esi,%ecx
 60d:	74 24                	je     633 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 60f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 611:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 616:	5b                   	pop    %ebx
 617:	5e                   	pop    %esi
 618:	5f                   	pop    %edi
 619:	5d                   	pop    %ebp
 61a:	c3                   	ret    
 61b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 61c:	03 72 04             	add    0x4(%edx),%esi
 61f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 622:	8b 10                	mov    (%eax),%edx
 624:	8b 12                	mov    (%edx),%edx
 626:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 629:	8b 50 04             	mov    0x4(%eax),%edx
 62c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62f:	39 f1                	cmp    %esi,%ecx
 631:	75 dc                	jne    60f <free+0x47>
    p->s.size += bp->s.size;
 633:	03 53 fc             	add    -0x4(%ebx),%edx
 636:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 639:	8b 53 f8             	mov    -0x8(%ebx),%edx
 63c:	89 10                	mov    %edx,(%eax)
  freep = p;
 63e:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 643:	5b                   	pop    %ebx
 644:	5e                   	pop    %esi
 645:	5f                   	pop    %edi
 646:	5d                   	pop    %ebp
 647:	c3                   	ret    

00000648 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 648:	55                   	push   %ebp
 649:	89 e5                	mov    %esp,%ebp
 64b:	57                   	push   %edi
 64c:	56                   	push   %esi
 64d:	53                   	push   %ebx
 64e:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	8d 70 07             	lea    0x7(%eax),%esi
 657:	c1 ee 03             	shr    $0x3,%esi
 65a:	46                   	inc    %esi
  if((prevp = freep) == 0){
 65b:	8b 3d 60 0a 00 00    	mov    0xa60,%edi
 661:	85 ff                	test   %edi,%edi
 663:	0f 84 a3 00 00 00    	je     70c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 669:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 66b:	8b 48 04             	mov    0x4(%eax),%ecx
 66e:	39 f1                	cmp    %esi,%ecx
 670:	73 67                	jae    6d9 <malloc+0x91>
 672:	89 f3                	mov    %esi,%ebx
 674:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 67a:	0f 82 80 00 00 00    	jb     700 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 680:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 687:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 68a:	eb 11                	jmp    69d <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68c:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 68e:	8b 4a 04             	mov    0x4(%edx),%ecx
 691:	39 f1                	cmp    %esi,%ecx
 693:	73 4b                	jae    6e0 <malloc+0x98>
 695:	8b 3d 60 0a 00 00    	mov    0xa60,%edi
 69b:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 69d:	39 c7                	cmp    %eax,%edi
 69f:	75 eb                	jne    68c <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 6a1:	83 ec 0c             	sub    $0xc,%esp
 6a4:	ff 75 e4             	pushl  -0x1c(%ebp)
 6a7:	e8 d5 fc ff ff       	call   381 <sbrk>
  if(p == (char*)-1)
 6ac:	83 c4 10             	add    $0x10,%esp
 6af:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b2:	74 1b                	je     6cf <malloc+0x87>
  hp->s.size = nu;
 6b4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6b7:	83 ec 0c             	sub    $0xc,%esp
 6ba:	83 c0 08             	add    $0x8,%eax
 6bd:	50                   	push   %eax
 6be:	e8 05 ff ff ff       	call   5c8 <free>
  return freep;
 6c3:	a1 60 0a 00 00       	mov    0xa60,%eax
      if((p = morecore(nunits)) == 0)
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	85 c0                	test   %eax,%eax
 6cd:	75 bd                	jne    68c <malloc+0x44>
        return 0;
 6cf:	31 c0                	xor    %eax,%eax
  }
}
 6d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d4:	5b                   	pop    %ebx
 6d5:	5e                   	pop    %esi
 6d6:	5f                   	pop    %edi
 6d7:	5d                   	pop    %ebp
 6d8:	c3                   	ret    
    if(p->s.size >= nunits){
 6d9:	89 c2                	mov    %eax,%edx
 6db:	89 f8                	mov    %edi,%eax
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6e0:	39 ce                	cmp    %ecx,%esi
 6e2:	74 54                	je     738 <malloc+0xf0>
        p->s.size -= nunits;
 6e4:	29 f1                	sub    %esi,%ecx
 6e6:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 6e9:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 6ec:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 6ef:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 6f4:	8d 42 08             	lea    0x8(%edx),%eax
}
 6f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6fa:	5b                   	pop    %ebx
 6fb:	5e                   	pop    %esi
 6fc:	5f                   	pop    %edi
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    
 6ff:	90                   	nop
 700:	bb 00 10 00 00       	mov    $0x1000,%ebx
 705:	e9 76 ff ff ff       	jmp    680 <malloc+0x38>
 70a:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 70c:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 713:	0a 00 00 
 716:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 71d:	0a 00 00 
    base.s.size = 0;
 720:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 727:	00 00 00 
 72a:	bf 64 0a 00 00       	mov    $0xa64,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	89 f8                	mov    %edi,%eax
 731:	e9 3c ff ff ff       	jmp    672 <malloc+0x2a>
 736:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 738:	8b 0a                	mov    (%edx),%ecx
 73a:	89 08                	mov    %ecx,(%eax)
 73c:	eb b1                	jmp    6ef <malloc+0xa7>
