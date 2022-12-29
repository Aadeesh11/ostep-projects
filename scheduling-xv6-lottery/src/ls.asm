
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

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

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 20                	jle    3d <main+0x3d>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 33                	pushl  (%ebx)
  29:	e8 b2 00 00 00       	call   e0 <ls>
  for(i=1; i<argc; i++)
  2e:	83 c3 04             	add    $0x4,%ebx
  31:	83 c4 10             	add    $0x10,%esp
  34:	39 f3                	cmp    %esi,%ebx
  36:	75 ec                	jne    24 <main+0x24>
  exit();
  38:	e8 68 04 00 00       	call   4a5 <exit>
    ls(".");
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	68 34 09 00 00       	push   $0x934
  45:	e8 96 00 00 00       	call   e0 <ls>
    exit();
  4a:	e8 56 04 00 00       	call   4a5 <exit>
  4f:	90                   	nop

00000050 <fmtname>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	56                   	push   %esi
  5c:	e8 e7 02 00 00       	call   348 <strlen>
  61:	83 c4 10             	add    $0x10,%esp
  64:	01 f0                	add    %esi,%eax
  66:	89 c3                	mov    %eax,%ebx
  68:	73 0b                	jae    75 <fmtname+0x25>
  6a:	eb 0e                	jmp    7a <fmtname+0x2a>
  6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  6f:	39 c6                	cmp    %eax,%esi
  71:	77 08                	ja     7b <fmtname+0x2b>
  73:	89 c3                	mov    %eax,%ebx
  75:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  78:	75 f2                	jne    6c <fmtname+0x1c>
  7a:	43                   	inc    %ebx
  if(strlen(p) >= DIRSIZ)
  7b:	83 ec 0c             	sub    $0xc,%esp
  7e:	53                   	push   %ebx
  7f:	e8 c4 02 00 00       	call   348 <strlen>
  84:	83 c4 10             	add    $0x10,%esp
  87:	83 f8 0d             	cmp    $0xd,%eax
  8a:	77 4a                	ja     d6 <fmtname+0x86>
  memmove(buf, p, strlen(p));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 b3 02 00 00       	call   348 <strlen>
  95:	83 c4 0c             	add    $0xc,%esp
  98:	50                   	push   %eax
  99:	53                   	push   %ebx
  9a:	68 58 0c 00 00       	push   $0xc58
  9f:	e8 d8 03 00 00       	call   47c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  a4:	89 1c 24             	mov    %ebx,(%esp)
  a7:	e8 9c 02 00 00       	call   348 <strlen>
  ac:	89 c6                	mov    %eax,%esi
  ae:	89 1c 24             	mov    %ebx,(%esp)
  b1:	e8 92 02 00 00       	call   348 <strlen>
  b6:	83 c4 0c             	add    $0xc,%esp
  b9:	ba 0e 00 00 00       	mov    $0xe,%edx
  be:	29 f2                	sub    %esi,%edx
  c0:	52                   	push   %edx
  c1:	6a 20                	push   $0x20
  c3:	05 58 0c 00 00       	add    $0xc58,%eax
  c8:	50                   	push   %eax
  c9:	e8 a2 02 00 00       	call   370 <memset>
  return buf;
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	bb 58 0c 00 00       	mov    $0xc58,%ebx
}
  d6:	89 d8                	mov    %ebx,%eax
  d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  db:	5b                   	pop    %ebx
  dc:	5e                   	pop    %esi
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop

000000e0 <ls>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	81 ec 64 02 00 00    	sub    $0x264,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
  ef:	6a 00                	push   $0x0
  f1:	57                   	push   %edi
  f2:	e8 ee 03 00 00       	call   4e5 <open>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	0f 88 82 01 00 00    	js     284 <ls+0x1a4>
 102:	89 c3                	mov    %eax,%ebx
  if(fstat(fd, &st) < 0){
 104:	83 ec 08             	sub    $0x8,%esp
 107:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 10d:	56                   	push   %esi
 10e:	50                   	push   %eax
 10f:	e8 e9 03 00 00       	call   4fd <fstat>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	0f 88 99 01 00 00    	js     2b8 <ls+0x1d8>
  switch(st.type){
 11f:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 125:	66 83 f8 01          	cmp    $0x1,%ax
 129:	74 59                	je     184 <ls+0xa4>
 12b:	66 83 f8 02          	cmp    $0x2,%ax
 12f:	74 17                	je     148 <ls+0x68>
  close(fd);
 131:	83 ec 0c             	sub    $0xc,%esp
 134:	53                   	push   %ebx
 135:	e8 93 03 00 00       	call   4cd <close>
 13a:	83 c4 10             	add    $0x10,%esp
}
 13d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 148:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 14e:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 154:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 15a:	83 ec 0c             	sub    $0xc,%esp
 15d:	57                   	push   %edi
 15e:	e8 ed fe ff ff       	call   50 <fmtname>
 163:	59                   	pop    %ecx
 164:	5f                   	pop    %edi
 165:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 16b:	52                   	push   %edx
 16c:	56                   	push   %esi
 16d:	6a 02                	push   $0x2
 16f:	50                   	push   %eax
 170:	68 14 09 00 00       	push   $0x914
 175:	6a 01                	push   $0x1
 177:	e8 64 04 00 00       	call   5e0 <printf>
    break;
 17c:	83 c4 20             	add    $0x20,%esp
 17f:	eb b0                	jmp    131 <ls+0x51>
 181:	8d 76 00             	lea    0x0(%esi),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	57                   	push   %edi
 188:	e8 bb 01 00 00       	call   348 <strlen>
 18d:	83 c0 10             	add    $0x10,%eax
 190:	83 c4 10             	add    $0x10,%esp
 193:	3d 00 02 00 00       	cmp    $0x200,%eax
 198:	0f 87 02 01 00 00    	ja     2a0 <ls+0x1c0>
    strcpy(buf, path);
 19e:	83 ec 08             	sub    $0x8,%esp
 1a1:	57                   	push   %edi
 1a2:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1a8:	57                   	push   %edi
 1a9:	e8 46 01 00 00       	call   2f4 <strcpy>
    p = buf+strlen(buf);
 1ae:	89 3c 24             	mov    %edi,(%esp)
 1b1:	e8 92 01 00 00       	call   348 <strlen>
 1b6:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
 1b9:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1bf:	8d 44 07 01          	lea    0x1(%edi,%eax,1),%eax
 1c3:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1c9:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	90                   	nop
 1d0:	50                   	push   %eax
 1d1:	6a 10                	push   $0x10
 1d3:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1d9:	50                   	push   %eax
 1da:	53                   	push   %ebx
 1db:	e8 dd 02 00 00       	call   4bd <read>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	83 f8 10             	cmp    $0x10,%eax
 1e6:	0f 85 45 ff ff ff    	jne    131 <ls+0x51>
      if(de.inum == 0)
 1ec:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1f3:	00 
 1f4:	74 da                	je     1d0 <ls+0xf0>
      memmove(p, de.name, DIRSIZ);
 1f6:	50                   	push   %eax
 1f7:	6a 0e                	push   $0xe
 1f9:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 1ff:	50                   	push   %eax
 200:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 206:	e8 71 02 00 00       	call   47c <memmove>
      p[DIRSIZ] = 0;
 20b:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 211:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 215:	58                   	pop    %eax
 216:	5a                   	pop    %edx
 217:	56                   	push   %esi
 218:	57                   	push   %edi
 219:	e8 e2 01 00 00       	call   400 <stat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	85 c0                	test   %eax,%eax
 223:	0f 88 b3 00 00 00    	js     2dc <ls+0x1fc>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 229:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 22f:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 235:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 23b:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 241:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 248:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	57                   	push   %edi
 252:	e8 f9 fd ff ff       	call   50 <fmtname>
 257:	5a                   	pop    %edx
 258:	59                   	pop    %ecx
 259:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 25f:	51                   	push   %ecx
 260:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 266:	52                   	push   %edx
 267:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 26d:	50                   	push   %eax
 26e:	68 14 09 00 00       	push   $0x914
 273:	6a 01                	push   $0x1
 275:	e8 66 03 00 00       	call   5e0 <printf>
 27a:	83 c4 20             	add    $0x20,%esp
 27d:	e9 4e ff ff ff       	jmp    1d0 <ls+0xf0>
 282:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 284:	50                   	push   %eax
 285:	57                   	push   %edi
 286:	68 ec 08 00 00       	push   $0x8ec
 28b:	6a 02                	push   $0x2
 28d:	e8 4e 03 00 00       	call   5e0 <printf>
    return;
 292:	83 c4 10             	add    $0x10,%esp
}
 295:	8d 65 f4             	lea    -0xc(%ebp),%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "ls: path too long\n");
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	68 21 09 00 00       	push   $0x921
 2a8:	6a 01                	push   $0x1
 2aa:	e8 31 03 00 00       	call   5e0 <printf>
      break;
 2af:	83 c4 10             	add    $0x10,%esp
 2b2:	e9 7a fe ff ff       	jmp    131 <ls+0x51>
 2b7:	90                   	nop
    printf(2, "ls: cannot stat %s\n", path);
 2b8:	50                   	push   %eax
 2b9:	57                   	push   %edi
 2ba:	68 00 09 00 00       	push   $0x900
 2bf:	6a 02                	push   $0x2
 2c1:	e8 1a 03 00 00       	call   5e0 <printf>
    close(fd);
 2c6:	89 1c 24             	mov    %ebx,(%esp)
 2c9:	e8 ff 01 00 00       	call   4cd <close>
    return;
 2ce:	83 c4 10             	add    $0x10,%esp
}
 2d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d4:	5b                   	pop    %ebx
 2d5:	5e                   	pop    %esi
 2d6:	5f                   	pop    %edi
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 2dc:	50                   	push   %eax
 2dd:	57                   	push   %edi
 2de:	68 00 09 00 00       	push   $0x900
 2e3:	6a 01                	push   $0x1
 2e5:	e8 f6 02 00 00       	call   5e0 <printf>
        continue;
 2ea:	83 c4 10             	add    $0x10,%esp
 2ed:	e9 de fe ff ff       	jmp    1d0 <ls+0xf0>
 2f2:	66 90                	xchg   %ax,%ax

000002f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fe:	31 c0                	xor    %eax,%eax
 300:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 303:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 306:	40                   	inc    %eax
 307:	84 d2                	test   %dl,%dl
 309:	75 f5                	jne    300 <strcpy+0xc>
    ;
  return os;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	5b                   	pop    %ebx
 30e:	5d                   	pop    %ebp
 30f:	c3                   	ret    

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 5d 08             	mov    0x8(%ebp),%ebx
 317:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 31a:	0f b6 03             	movzbl (%ebx),%eax
 31d:	0f b6 0a             	movzbl (%edx),%ecx
 320:	84 c0                	test   %al,%al
 322:	75 10                	jne    334 <strcmp+0x24>
 324:	eb 1a                	jmp    340 <strcmp+0x30>
 326:	66 90                	xchg   %ax,%ax
    p++, q++;
 328:	43                   	inc    %ebx
 329:	42                   	inc    %edx
  while(*p && *p == *q)
 32a:	0f b6 03             	movzbl (%ebx),%eax
 32d:	0f b6 0a             	movzbl (%edx),%ecx
 330:	84 c0                	test   %al,%al
 332:	74 0c                	je     340 <strcmp+0x30>
 334:	38 c8                	cmp    %cl,%al
 336:	74 f0                	je     328 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 338:	29 c8                	sub    %ecx,%eax
}
 33a:	5b                   	pop    %ebx
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
 340:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 342:	29 c8                	sub    %ecx,%eax
}
 344:	5b                   	pop    %ebx
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	90                   	nop

00000348 <strlen>:

uint
strlen(const char *s)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 34e:	80 3a 00             	cmpb   $0x0,(%edx)
 351:	74 15                	je     368 <strlen+0x20>
 353:	31 c0                	xor    %eax,%eax
 355:	8d 76 00             	lea    0x0(%esi),%esi
 358:	40                   	inc    %eax
 359:	89 c1                	mov    %eax,%ecx
 35b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 35f:	75 f7                	jne    358 <strlen+0x10>
    ;
  return n;
}
 361:	89 c8                	mov    %ecx,%eax
 363:	5d                   	pop    %ebp
 364:	c3                   	ret    
 365:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 368:	31 c9                	xor    %ecx,%ecx
}
 36a:	89 c8                	mov    %ecx,%eax
 36c:	5d                   	pop    %ebp
 36d:	c3                   	ret    
 36e:	66 90                	xchg   %ax,%ax

00000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 374:	8b 7d 08             	mov    0x8(%ebp),%edi
 377:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	fc                   	cld    
 37e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	5f                   	pop    %edi
 384:	5d                   	pop    %ebp
 385:	c3                   	ret    
 386:	66 90                	xchg   %ax,%ax

00000388 <strchr>:

char*
strchr(const char *s, char c)
{
 388:	55                   	push   %ebp
 389:	89 e5                	mov    %esp,%ebp
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 391:	8a 10                	mov    (%eax),%dl
 393:	84 d2                	test   %dl,%dl
 395:	75 0c                	jne    3a3 <strchr+0x1b>
 397:	eb 13                	jmp    3ac <strchr+0x24>
 399:	8d 76 00             	lea    0x0(%esi),%esi
 39c:	40                   	inc    %eax
 39d:	8a 10                	mov    (%eax),%dl
 39f:	84 d2                	test   %dl,%dl
 3a1:	74 09                	je     3ac <strchr+0x24>
    if(*s == c)
 3a3:	38 d1                	cmp    %dl,%cl
 3a5:	75 f5                	jne    39c <strchr+0x14>
      return (char*)s;
  return 0;
}
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3ac:	31 c0                	xor    %eax,%eax
}
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b9:	8b 75 08             	mov    0x8(%ebp),%esi
 3bc:	bb 01 00 00 00       	mov    $0x1,%ebx
 3c1:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 3c3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c6:	eb 20                	jmp    3e8 <gets+0x38>
    cc = read(0, &c, 1);
 3c8:	50                   	push   %eax
 3c9:	6a 01                	push   $0x1
 3cb:	57                   	push   %edi
 3cc:	6a 00                	push   $0x0
 3ce:	e8 ea 00 00 00       	call   4bd <read>
    if(cc < 1)
 3d3:	83 c4 10             	add    $0x10,%esp
 3d6:	85 c0                	test   %eax,%eax
 3d8:	7e 16                	jle    3f0 <gets+0x40>
      break;
    buf[i++] = c;
 3da:	8a 45 e7             	mov    -0x19(%ebp),%al
 3dd:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 3df:	46                   	inc    %esi
 3e0:	3c 0a                	cmp    $0xa,%al
 3e2:	74 0c                	je     3f0 <gets+0x40>
 3e4:	3c 0d                	cmp    $0xd,%al
 3e6:	74 08                	je     3f0 <gets+0x40>
  for(i=0; i+1 < max; ){
 3e8:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 3eb:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3ee:	7f d8                	jg     3c8 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 3f0:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5f                   	pop    %edi
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    
 3fe:	66 90                	xchg   %ax,%ax

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	pushl  0x8(%ebp)
 40d:	e8 d3 00 00 00       	call   4e5 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
 419:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 41b:	83 ec 08             	sub    $0x8,%esp
 41e:	ff 75 0c             	pushl  0xc(%ebp)
 421:	50                   	push   %eax
 422:	e8 d6 00 00 00       	call   4fd <fstat>
 427:	89 c6                	mov    %eax,%esi
  close(fd);
 429:	89 1c 24             	mov    %ebx,(%esp)
 42c:	e8 9c 00 00 00       	call   4cd <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	89 f0                	mov    %esi,%eax
 436:	8d 65 f8             	lea    -0x8(%ebp),%esp
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	90                   	nop

00000448 <atoi>:

int
atoi(const char *s)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	53                   	push   %ebx
 44c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44f:	0f be 01             	movsbl (%ecx),%eax
 452:	8d 50 d0             	lea    -0x30(%eax),%edx
 455:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 458:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 45d:	77 16                	ja     475 <atoi+0x2d>
 45f:	90                   	nop
    n = n*10 + *s++ - '0';
 460:	41                   	inc    %ecx
 461:	8d 14 92             	lea    (%edx,%edx,4),%edx
 464:	01 d2                	add    %edx,%edx
 466:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 46a:	0f be 01             	movsbl (%ecx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x18>
  return n;
}
 475:	89 d0                	mov    %edx,%eax
 477:	5b                   	pop    %ebx
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    
 47a:	66 90                	xchg   %ax,%ax

0000047c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	57                   	push   %edi
 480:	56                   	push   %esi
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	8b 75 0c             	mov    0xc(%ebp),%esi
 487:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48a:	85 d2                	test   %edx,%edx
 48c:	7e 0b                	jle    499 <memmove+0x1d>
 48e:	01 c2                	add    %eax,%edx
  dst = vdst;
 490:	89 c7                	mov    %eax,%edi
 492:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 494:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 495:	39 fa                	cmp    %edi,%edx
 497:	75 fb                	jne    494 <memmove+0x18>
  return vdst;
}
 499:	5e                   	pop    %esi
 49a:	5f                   	pop    %edi
 49b:	5d                   	pop    %ebp
 49c:	c3                   	ret    

0000049d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49d:	b8 01 00 00 00       	mov    $0x1,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <exit>:
SYSCALL(exit)
 4a5:	b8 02 00 00 00       	mov    $0x2,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <wait>:
SYSCALL(wait)
 4ad:	b8 03 00 00 00       	mov    $0x3,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <pipe>:
SYSCALL(pipe)
 4b5:	b8 04 00 00 00       	mov    $0x4,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <read>:
SYSCALL(read)
 4bd:	b8 05 00 00 00       	mov    $0x5,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <write>:
SYSCALL(write)
 4c5:	b8 10 00 00 00       	mov    $0x10,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <close>:
SYSCALL(close)
 4cd:	b8 15 00 00 00       	mov    $0x15,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <kill>:
SYSCALL(kill)
 4d5:	b8 06 00 00 00       	mov    $0x6,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <exec>:
SYSCALL(exec)
 4dd:	b8 07 00 00 00       	mov    $0x7,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <open>:
SYSCALL(open)
 4e5:	b8 0f 00 00 00       	mov    $0xf,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <mknod>:
SYSCALL(mknod)
 4ed:	b8 11 00 00 00       	mov    $0x11,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <unlink>:
SYSCALL(unlink)
 4f5:	b8 12 00 00 00       	mov    $0x12,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <fstat>:
SYSCALL(fstat)
 4fd:	b8 08 00 00 00       	mov    $0x8,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <link>:
SYSCALL(link)
 505:	b8 13 00 00 00       	mov    $0x13,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <mkdir>:
SYSCALL(mkdir)
 50d:	b8 14 00 00 00       	mov    $0x14,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <chdir>:
SYSCALL(chdir)
 515:	b8 09 00 00 00       	mov    $0x9,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <dup>:
SYSCALL(dup)
 51d:	b8 0a 00 00 00       	mov    $0xa,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <getpid>:
SYSCALL(getpid)
 525:	b8 0b 00 00 00       	mov    $0xb,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <sbrk>:
SYSCALL(sbrk)
 52d:	b8 0c 00 00 00       	mov    $0xc,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <sleep>:
SYSCALL(sleep)
 535:	b8 0d 00 00 00       	mov    $0xd,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <uptime>:
SYSCALL(uptime)
 53d:	b8 0e 00 00 00       	mov    $0xe,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <settickets>:
SYSCALL(settickets)
 545:	b8 16 00 00 00       	mov    $0x16,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <getpinfo>:
SYSCALL(getpinfo)
 54d:	b8 17 00 00 00       	mov    $0x17,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    
 555:	66 90                	xchg   %ax,%ax
 557:	90                   	nop

00000558 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	53                   	push   %ebx
 55e:	83 ec 3c             	sub    $0x3c,%esp
 561:	89 45 bc             	mov    %eax,-0x44(%ebp)
 564:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 567:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 569:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56c:	85 db                	test   %ebx,%ebx
 56e:	74 04                	je     574 <printint+0x1c>
 570:	85 d2                	test   %edx,%edx
 572:	78 68                	js     5dc <printint+0x84>
  neg = 0;
 574:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 57b:	31 ff                	xor    %edi,%edi
 57d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 580:	89 c8                	mov    %ecx,%eax
 582:	31 d2                	xor    %edx,%edx
 584:	f7 75 c4             	divl   -0x3c(%ebp)
 587:	89 fb                	mov    %edi,%ebx
 589:	8d 7f 01             	lea    0x1(%edi),%edi
 58c:	8a 92 40 09 00 00    	mov    0x940(%edx),%dl
 592:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 596:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 599:	89 c1                	mov    %eax,%ecx
 59b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 59e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 5a1:	76 dd                	jbe    580 <printint+0x28>
  if(neg)
 5a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5a6:	85 c9                	test   %ecx,%ecx
 5a8:	74 09                	je     5b3 <printint+0x5b>
    buf[i++] = '-';
 5aa:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 5af:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 5b1:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 5b3:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 5b7:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5ba:	eb 03                	jmp    5bf <printint+0x67>
 5bc:	8a 13                	mov    (%ebx),%dl
 5be:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 5bf:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 5c2:	50                   	push   %eax
 5c3:	6a 01                	push   $0x1
 5c5:	56                   	push   %esi
 5c6:	57                   	push   %edi
 5c7:	e8 f9 fe ff ff       	call   4c5 <write>
  while(--i >= 0)
 5cc:	83 c4 10             	add    $0x10,%esp
 5cf:	39 de                	cmp    %ebx,%esi
 5d1:	75 e9                	jne    5bc <printint+0x64>
}
 5d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    
 5db:	90                   	nop
    x = -xx;
 5dc:	f7 d9                	neg    %ecx
 5de:	eb 9b                	jmp    57b <printint+0x23>

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5ec:	8a 1e                	mov    (%esi),%bl
 5ee:	84 db                	test   %bl,%bl
 5f0:	0f 84 a3 00 00 00    	je     699 <printf+0xb9>
 5f6:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 5f7:	8d 45 10             	lea    0x10(%ebp),%eax
 5fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 5fd:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 5ff:	8d 7d e7             	lea    -0x19(%ebp),%edi
 602:	eb 29                	jmp    62d <printf+0x4d>
 604:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 607:	83 f8 25             	cmp    $0x25,%eax
 60a:	0f 84 94 00 00 00    	je     6a4 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 610:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 613:	50                   	push   %eax
 614:	6a 01                	push   $0x1
 616:	57                   	push   %edi
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 a6 fe ff ff       	call   4c5 <write>
        putc(fd, c);
 61f:	83 c4 10             	add    $0x10,%esp
 622:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 625:	46                   	inc    %esi
 626:	8a 5e ff             	mov    -0x1(%esi),%bl
 629:	84 db                	test   %bl,%bl
 62b:	74 6c                	je     699 <printf+0xb9>
    c = fmt[i] & 0xff;
 62d:	0f be cb             	movsbl %bl,%ecx
 630:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 633:	85 d2                	test   %edx,%edx
 635:	74 cd                	je     604 <printf+0x24>
      }
    } else if(state == '%'){
 637:	83 fa 25             	cmp    $0x25,%edx
 63a:	75 e9                	jne    625 <printf+0x45>
      if(c == 'd'){
 63c:	83 f8 64             	cmp    $0x64,%eax
 63f:	0f 84 97 00 00 00    	je     6dc <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 645:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 64b:	83 f9 70             	cmp    $0x70,%ecx
 64e:	74 60                	je     6b0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 650:	83 f8 73             	cmp    $0x73,%eax
 653:	0f 84 8f 00 00 00    	je     6e8 <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 659:	83 f8 63             	cmp    $0x63,%eax
 65c:	0f 84 d6 00 00 00    	je     738 <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 662:	83 f8 25             	cmp    $0x25,%eax
 665:	0f 84 c1 00 00 00    	je     72c <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 66f:	50                   	push   %eax
 670:	6a 01                	push   $0x1
 672:	57                   	push   %edi
 673:	ff 75 08             	pushl  0x8(%ebp)
 676:	e8 4a fe ff ff       	call   4c5 <write>
        putc(fd, c);
 67b:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 67e:	83 c4 0c             	add    $0xc,%esp
 681:	6a 01                	push   $0x1
 683:	57                   	push   %edi
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 39 fe ff ff       	call   4c5 <write>
        putc(fd, c);
 68c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68f:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 691:	46                   	inc    %esi
 692:	8a 5e ff             	mov    -0x1(%esi),%bl
 695:	84 db                	test   %bl,%bl
 697:	75 94                	jne    62d <printf+0x4d>
    }
  }
}
 699:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69c:	5b                   	pop    %ebx
 69d:	5e                   	pop    %esi
 69e:	5f                   	pop    %edi
 69f:	5d                   	pop    %ebp
 6a0:	c3                   	ret    
 6a1:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 6a4:	ba 25 00 00 00       	mov    $0x25,%edx
 6a9:	e9 77 ff ff ff       	jmp    625 <printf+0x45>
 6ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	6a 00                	push   $0x0
 6b5:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6bd:	8b 13                	mov    (%ebx),%edx
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	e8 91 fe ff ff       	call   558 <printint>
        ap++;
 6c7:	89 d8                	mov    %ebx,%eax
 6c9:	83 c0 04             	add    $0x4,%eax
 6cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6cf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d2:	31 d2                	xor    %edx,%edx
        ap++;
 6d4:	e9 4c ff ff ff       	jmp    625 <printf+0x45>
 6d9:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6dc:	83 ec 0c             	sub    $0xc,%esp
 6df:	6a 01                	push   $0x1
 6e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6e6:	eb d2                	jmp    6ba <printf+0xda>
        s = (char*)*ap;
 6e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6eb:	8b 18                	mov    (%eax),%ebx
        ap++;
 6ed:	83 c0 04             	add    $0x4,%eax
 6f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6f3:	85 db                	test   %ebx,%ebx
 6f5:	74 65                	je     75c <printf+0x17c>
        while(*s != 0){
 6f7:	8a 03                	mov    (%ebx),%al
 6f9:	84 c0                	test   %al,%al
 6fb:	74 70                	je     76d <printf+0x18d>
 6fd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 700:	89 de                	mov    %ebx,%esi
 702:	8b 5d 08             	mov    0x8(%ebp),%ebx
 705:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 708:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 70b:	50                   	push   %eax
 70c:	6a 01                	push   $0x1
 70e:	57                   	push   %edi
 70f:	53                   	push   %ebx
 710:	e8 b0 fd ff ff       	call   4c5 <write>
          s++;
 715:	46                   	inc    %esi
        while(*s != 0){
 716:	8a 06                	mov    (%esi),%al
 718:	83 c4 10             	add    $0x10,%esp
 71b:	84 c0                	test   %al,%al
 71d:	75 e9                	jne    708 <printf+0x128>
 71f:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 722:	31 d2                	xor    %edx,%edx
 724:	e9 fc fe ff ff       	jmp    625 <printf+0x45>
 729:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 72c:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 72f:	52                   	push   %edx
 730:	e9 4c ff ff ff       	jmp    681 <printf+0xa1>
 735:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 738:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 73b:	8b 03                	mov    (%ebx),%eax
 73d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 740:	51                   	push   %ecx
 741:	6a 01                	push   $0x1
 743:	57                   	push   %edi
 744:	ff 75 08             	pushl  0x8(%ebp)
 747:	e8 79 fd ff ff       	call   4c5 <write>
        ap++;
 74c:	83 c3 04             	add    $0x4,%ebx
 74f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 752:	83 c4 10             	add    $0x10,%esp
      state = 0;
 755:	31 d2                	xor    %edx,%edx
 757:	e9 c9 fe ff ff       	jmp    625 <printf+0x45>
          s = "(null)";
 75c:	bb 36 09 00 00       	mov    $0x936,%ebx
        while(*s != 0){
 761:	b0 28                	mov    $0x28,%al
 763:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 766:	89 de                	mov    %ebx,%esi
 768:	8b 5d 08             	mov    0x8(%ebp),%ebx
 76b:	eb 9b                	jmp    708 <printf+0x128>
      state = 0;
 76d:	31 d2                	xor    %edx,%edx
 76f:	e9 b1 fe ff ff       	jmp    625 <printf+0x45>

00000774 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	57                   	push   %edi
 778:	56                   	push   %esi
 779:	53                   	push   %ebx
 77a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	a1 68 0c 00 00       	mov    0xc68,%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	39 c8                	cmp    %ecx,%eax
 789:	73 11                	jae    79c <free+0x28>
 78b:	90                   	nop
 78c:	39 d1                	cmp    %edx,%ecx
 78e:	72 14                	jb     7a4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 d0                	cmp    %edx,%eax
 792:	73 10                	jae    7a4 <free+0x30>
{
 794:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	8b 10                	mov    (%eax),%edx
 798:	39 c8                	cmp    %ecx,%eax
 79a:	72 f0                	jb     78c <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	39 d0                	cmp    %edx,%eax
 79e:	72 f4                	jb     794 <free+0x20>
 7a0:	39 d1                	cmp    %edx,%ecx
 7a2:	73 f0                	jae    794 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7a7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7aa:	39 fa                	cmp    %edi,%edx
 7ac:	74 1a                	je     7c8 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7ae:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7b1:	8b 50 04             	mov    0x4(%eax),%edx
 7b4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b7:	39 f1                	cmp    %esi,%ecx
 7b9:	74 24                	je     7df <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7bb:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7bd:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 7c2:	5b                   	pop    %ebx
 7c3:	5e                   	pop    %esi
 7c4:	5f                   	pop    %edi
 7c5:	5d                   	pop    %ebp
 7c6:	c3                   	ret    
 7c7:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7c8:	03 72 04             	add    0x4(%edx),%esi
 7cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 10                	mov    (%eax),%edx
 7d0:	8b 12                	mov    (%edx),%edx
 7d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7db:	39 f1                	cmp    %esi,%ecx
 7dd:	75 dc                	jne    7bb <free+0x47>
    p->s.size += bp->s.size;
 7df:	03 53 fc             	add    -0x4(%ebx),%edx
 7e2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ea:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 7ef:	5b                   	pop    %ebx
 7f0:	5e                   	pop    %esi
 7f1:	5f                   	pop    %edi
 7f2:	5d                   	pop    %ebp
 7f3:	c3                   	ret    

000007f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	57                   	push   %edi
 7f8:	56                   	push   %esi
 7f9:	53                   	push   %ebx
 7fa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	8d 70 07             	lea    0x7(%eax),%esi
 803:	c1 ee 03             	shr    $0x3,%esi
 806:	46                   	inc    %esi
  if((prevp = freep) == 0){
 807:	8b 3d 68 0c 00 00    	mov    0xc68,%edi
 80d:	85 ff                	test   %edi,%edi
 80f:	0f 84 a3 00 00 00    	je     8b8 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 815:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 817:	8b 48 04             	mov    0x4(%eax),%ecx
 81a:	39 f1                	cmp    %esi,%ecx
 81c:	73 67                	jae    885 <malloc+0x91>
 81e:	89 f3                	mov    %esi,%ebx
 820:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 826:	0f 82 80 00 00 00    	jb     8ac <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 82c:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 833:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 836:	eb 11                	jmp    849 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 83a:	8b 4a 04             	mov    0x4(%edx),%ecx
 83d:	39 f1                	cmp    %esi,%ecx
 83f:	73 4b                	jae    88c <malloc+0x98>
 841:	8b 3d 68 0c 00 00    	mov    0xc68,%edi
 847:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 849:	39 c7                	cmp    %eax,%edi
 84b:	75 eb                	jne    838 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 84d:	83 ec 0c             	sub    $0xc,%esp
 850:	ff 75 e4             	pushl  -0x1c(%ebp)
 853:	e8 d5 fc ff ff       	call   52d <sbrk>
  if(p == (char*)-1)
 858:	83 c4 10             	add    $0x10,%esp
 85b:	83 f8 ff             	cmp    $0xffffffff,%eax
 85e:	74 1b                	je     87b <malloc+0x87>
  hp->s.size = nu;
 860:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	83 c0 08             	add    $0x8,%eax
 869:	50                   	push   %eax
 86a:	e8 05 ff ff ff       	call   774 <free>
  return freep;
 86f:	a1 68 0c 00 00       	mov    0xc68,%eax
      if((p = morecore(nunits)) == 0)
 874:	83 c4 10             	add    $0x10,%esp
 877:	85 c0                	test   %eax,%eax
 879:	75 bd                	jne    838 <malloc+0x44>
        return 0;
 87b:	31 c0                	xor    %eax,%eax
  }
}
 87d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 880:	5b                   	pop    %ebx
 881:	5e                   	pop    %esi
 882:	5f                   	pop    %edi
 883:	5d                   	pop    %ebp
 884:	c3                   	ret    
    if(p->s.size >= nunits){
 885:	89 c2                	mov    %eax,%edx
 887:	89 f8                	mov    %edi,%eax
 889:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 88c:	39 ce                	cmp    %ecx,%esi
 88e:	74 54                	je     8e4 <malloc+0xf0>
        p->s.size -= nunits;
 890:	29 f1                	sub    %esi,%ecx
 892:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 895:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 898:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 89b:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 8a0:	8d 42 08             	lea    0x8(%edx),%eax
}
 8a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8a6:	5b                   	pop    %ebx
 8a7:	5e                   	pop    %esi
 8a8:	5f                   	pop    %edi
 8a9:	5d                   	pop    %ebp
 8aa:	c3                   	ret    
 8ab:	90                   	nop
 8ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8b1:	e9 76 ff ff ff       	jmp    82c <malloc+0x38>
 8b6:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8b8:	c7 05 68 0c 00 00 6c 	movl   $0xc6c,0xc68
 8bf:	0c 00 00 
 8c2:	c7 05 6c 0c 00 00 6c 	movl   $0xc6c,0xc6c
 8c9:	0c 00 00 
    base.s.size = 0;
 8cc:	c7 05 70 0c 00 00 00 	movl   $0x0,0xc70
 8d3:	00 00 00 
 8d6:	bf 6c 0c 00 00       	mov    $0xc6c,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8db:	89 f8                	mov    %edi,%eax
 8dd:	e9 3c ff ff ff       	jmp    81e <malloc+0x2a>
 8e2:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 8e4:	8b 0a                	mov    (%edx),%ecx
 8e6:	89 08                	mov    %ecx,(%eax)
 8e8:	eb b1                	jmp    89b <malloc+0xa7>
