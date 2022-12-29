
_grep:     file format elf32-i386


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
  16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 65                	jle    84 <main+0x84>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  1f:	8b 7b 04             	mov    0x4(%ebx),%edi

  if(argc <= 2){
  22:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  26:	74 6f                	je     97 <main+0x97>
  28:	83 c3 08             	add    $0x8,%ebx
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  30:	eb 26                	jmp    58 <main+0x58>
  32:	66 90                	xchg   %ax,%ax
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  34:	83 ec 08             	sub    $0x8,%esp
  37:	50                   	push   %eax
  38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  3b:	57                   	push   %edi
  3c:	e8 83 01 00 00       	call   1c4 <grep>
    close(fd);
  41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 35 04 00 00       	call   481 <close>
  for(i = 2; i < argc; i++){
  4c:	46                   	inc    %esi
  4d:	83 c3 04             	add    $0x4,%ebx
  50:	83 c4 10             	add    $0x10,%esp
  53:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  56:	7e 27                	jle    7f <main+0x7f>
    if((fd = open(argv[i], 0)) < 0){
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 00                	push   $0x0
  5d:	ff 33                	pushl  (%ebx)
  5f:	e8 35 04 00 00       	call   499 <open>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	79 c9                	jns    34 <main+0x34>
      printf(1, "grep: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	pushl  (%ebx)
  6e:	68 c0 08 00 00       	push   $0x8c0
  73:	6a 01                	push   $0x1
  75:	e8 1a 05 00 00       	call   594 <printf>
      exit();
  7a:	e8 da 03 00 00       	call   459 <exit>
  }
  exit();
  7f:	e8 d5 03 00 00       	call   459 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  84:	51                   	push   %ecx
  85:	51                   	push   %ecx
  86:	68 a0 08 00 00       	push   $0x8a0
  8b:	6a 02                	push   $0x2
  8d:	e8 02 05 00 00       	call   594 <printf>
    exit();
  92:	e8 c2 03 00 00       	call   459 <exit>
    grep(pattern, 0);
  97:	52                   	push   %edx
  98:	52                   	push   %edx
  99:	6a 00                	push   $0x0
  9b:	57                   	push   %edi
  9c:	e8 23 01 00 00       	call   1c4 <grep>
    exit();
  a1:	e8 b3 03 00 00       	call   459 <exit>
  a6:	66 90                	xchg   %ax,%ax

000000a8 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	56                   	push   %esi
  ad:	53                   	push   %ebx
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  b4:	8b 75 0c             	mov    0xc(%ebp),%esi
  b7:	8b 7d 10             	mov    0x10(%ebp),%edi
  ba:	66 90                	xchg   %ax,%ax
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  bc:	83 ec 08             	sub    $0x8,%esp
  bf:	57                   	push   %edi
  c0:	56                   	push   %esi
  c1:	e8 32 00 00 00       	call   f8 <matchhere>
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	85 c0                	test   %eax,%eax
  cb:	75 1b                	jne    e8 <matchstar+0x40>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  cd:	0f be 17             	movsbl (%edi),%edx
  d0:	84 d2                	test   %dl,%dl
  d2:	74 0a                	je     de <matchstar+0x36>
  d4:	47                   	inc    %edi
  d5:	39 da                	cmp    %ebx,%edx
  d7:	74 e3                	je     bc <matchstar+0x14>
  d9:	83 fb 2e             	cmp    $0x2e,%ebx
  dc:	74 de                	je     bc <matchstar+0x14>
  return 0;
}
  de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  e1:	5b                   	pop    %ebx
  e2:	5e                   	pop    %esi
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    
  e6:	66 90                	xchg   %ax,%ax
      return 1;
  e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  f0:	5b                   	pop    %ebx
  f1:	5e                   	pop    %esi
  f2:	5f                   	pop    %edi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 76 00             	lea    0x0(%esi),%esi

000000f8 <matchhere>:
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	56                   	push   %esi
  fc:	53                   	push   %ebx
  fd:	8b 55 08             	mov    0x8(%ebp),%edx
 100:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '\0')
 103:	0f be 0a             	movsbl (%edx),%ecx
 106:	84 c9                	test   %cl,%cl
 108:	75 18                	jne    122 <matchhere+0x2a>
 10a:	eb 44                	jmp    150 <matchhere+0x58>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 10c:	84 db                	test   %bl,%bl
 10e:	74 34                	je     144 <matchhere+0x4c>
 110:	80 f9 2e             	cmp    $0x2e,%cl
 113:	74 04                	je     119 <matchhere+0x21>
 115:	38 d9                	cmp    %bl,%cl
 117:	75 2b                	jne    144 <matchhere+0x4c>
    return matchhere(re+1, text+1);
 119:	46                   	inc    %esi
 11a:	42                   	inc    %edx
  if(re[0] == '\0')
 11b:	84 c0                	test   %al,%al
 11d:	74 31                	je     150 <matchhere+0x58>
{
 11f:	0f be c8             	movsbl %al,%ecx
  if(re[1] == '*')
 122:	8a 42 01             	mov    0x1(%edx),%al
 125:	3c 2a                	cmp    $0x2a,%al
 127:	74 33                	je     15c <matchhere+0x64>
  if(re[0] == '$' && re[1] == '\0')
 129:	8a 1e                	mov    (%esi),%bl
 12b:	80 f9 24             	cmp    $0x24,%cl
 12e:	75 dc                	jne    10c <matchhere+0x14>
 130:	84 c0                	test   %al,%al
 132:	74 3e                	je     172 <matchhere+0x7a>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 134:	84 db                	test   %bl,%bl
 136:	74 0c                	je     144 <matchhere+0x4c>
 138:	80 fb 24             	cmp    $0x24,%bl
 13b:	75 07                	jne    144 <matchhere+0x4c>
    return matchhere(re+1, text+1);
 13d:	46                   	inc    %esi
 13e:	42                   	inc    %edx
  if(re[0] == '\0')
 13f:	eb de                	jmp    11f <matchhere+0x27>
 141:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 144:	31 c0                	xor    %eax,%eax
}
 146:	8d 65 f8             	lea    -0x8(%ebp),%esp
 149:	5b                   	pop    %ebx
 14a:	5e                   	pop    %esi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
 14d:	8d 76 00             	lea    0x0(%esi),%esi
    return 1;
 150:	b8 01 00 00 00       	mov    $0x1,%eax
}
 155:	8d 65 f8             	lea    -0x8(%ebp),%esp
 158:	5b                   	pop    %ebx
 159:	5e                   	pop    %esi
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    
    return matchstar(re[0], re+2, text);
 15c:	50                   	push   %eax
 15d:	56                   	push   %esi
 15e:	83 c2 02             	add    $0x2,%edx
 161:	52                   	push   %edx
 162:	51                   	push   %ecx
 163:	e8 40 ff ff ff       	call   a8 <matchstar>
 168:	83 c4 10             	add    $0x10,%esp
}
 16b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 16e:	5b                   	pop    %ebx
 16f:	5e                   	pop    %esi
 170:	5d                   	pop    %ebp
 171:	c3                   	ret    
    return *text == '\0';
 172:	31 c0                	xor    %eax,%eax
 174:	84 db                	test   %bl,%bl
 176:	0f 94 c0             	sete   %al
 179:	eb cb                	jmp    146 <matchhere+0x4e>
 17b:	90                   	nop

0000017c <match>:
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
 181:	8b 5d 08             	mov    0x8(%ebp),%ebx
 184:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 187:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 18a:	75 0b                	jne    197 <match+0x1b>
 18c:	eb 26                	jmp    1b4 <match+0x38>
 18e:	66 90                	xchg   %ax,%ax
  }while(*text++ != '\0');
 190:	46                   	inc    %esi
 191:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 195:	74 16                	je     1ad <match+0x31>
    if(matchhere(re, text))
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	56                   	push   %esi
 19b:	53                   	push   %ebx
 19c:	e8 57 ff ff ff       	call   f8 <matchhere>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	85 c0                	test   %eax,%eax
 1a6:	74 e8                	je     190 <match+0x14>
      return 1;
 1a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
    return matchhere(re+1, text);
 1b4:	43                   	inc    %ebx
 1b5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 1b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1be:	e9 35 ff ff ff       	jmp    f8 <matchhere>
 1c3:	90                   	nop

000001c4 <grep>:
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	56                   	push   %esi
 1c9:	53                   	push   %ebx
 1ca:	83 ec 1c             	sub    $0x1c,%esp
 1cd:	8b 75 08             	mov    0x8(%ebp),%esi
  m = 0;
 1d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1d7:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1d8:	50                   	push   %eax
 1d9:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 1de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 1e1:	29 c8                	sub    %ecx,%eax
 1e3:	50                   	push   %eax
 1e4:	8d 81 a0 0c 00 00    	lea    0xca0(%ecx),%eax
 1ea:	50                   	push   %eax
 1eb:	ff 75 0c             	pushl  0xc(%ebp)
 1ee:	e8 7e 02 00 00       	call   471 <read>
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	0f 8e a2 00 00 00    	jle    2a0 <grep+0xdc>
    m += n;
 1fe:	01 45 e4             	add    %eax,-0x1c(%ebp)
 201:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    buf[m] = '\0';
 204:	c6 81 a0 0c 00 00 00 	movb   $0x0,0xca0(%ecx)
    p = buf;
 20b:	bb a0 0c 00 00       	mov    $0xca0,%ebx
    while((q = strchr(p, '\n')) != 0){
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 0a                	push   $0xa
 215:	53                   	push   %ebx
 216:	e8 21 01 00 00       	call   33c <strchr>
 21b:	89 c7                	mov    %eax,%edi
 21d:	83 c4 10             	add    $0x10,%esp
 220:	85 c0                	test   %eax,%eax
 222:	74 3c                	je     260 <grep+0x9c>
      *q = 0;
 224:	c6 07 00             	movb   $0x0,(%edi)
      if(match(pattern, p)){
 227:	83 ec 08             	sub    $0x8,%esp
 22a:	53                   	push   %ebx
 22b:	56                   	push   %esi
 22c:	e8 4b ff ff ff       	call   17c <match>
 231:	83 c4 10             	add    $0x10,%esp
 234:	8d 57 01             	lea    0x1(%edi),%edx
 237:	85 c0                	test   %eax,%eax
 239:	75 05                	jne    240 <grep+0x7c>
      p = q+1;
 23b:	89 d3                	mov    %edx,%ebx
 23d:	eb d1                	jmp    210 <grep+0x4c>
 23f:	90                   	nop
        *q = '\n';
 240:	c6 07 0a             	movb   $0xa,(%edi)
        write(1, p, q+1 - p);
 243:	51                   	push   %ecx
 244:	89 d0                	mov    %edx,%eax
 246:	89 55 e0             	mov    %edx,-0x20(%ebp)
 249:	29 d8                	sub    %ebx,%eax
 24b:	50                   	push   %eax
 24c:	53                   	push   %ebx
 24d:	6a 01                	push   $0x1
 24f:	e8 25 02 00 00       	call   479 <write>
 254:	83 c4 10             	add    $0x10,%esp
 257:	8b 55 e0             	mov    -0x20(%ebp),%edx
      p = q+1;
 25a:	89 d3                	mov    %edx,%ebx
 25c:	eb b2                	jmp    210 <grep+0x4c>
 25e:	66 90                	xchg   %ax,%ax
    if(p == buf)
 260:	81 fb a0 0c 00 00    	cmp    $0xca0,%ebx
 266:	74 2c                	je     294 <grep+0xd0>
    if(m > 0){
 268:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 26b:	85 c9                	test   %ecx,%ecx
 26d:	0f 8e 65 ff ff ff    	jle    1d8 <grep+0x14>
      m -= p - buf;
 273:	89 d8                	mov    %ebx,%eax
 275:	2d a0 0c 00 00       	sub    $0xca0,%eax
 27a:	29 c1                	sub    %eax,%ecx
 27c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 27f:	52                   	push   %edx
 280:	51                   	push   %ecx
 281:	53                   	push   %ebx
 282:	68 a0 0c 00 00       	push   $0xca0
 287:	e8 a4 01 00 00       	call   430 <memmove>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	e9 44 ff ff ff       	jmp    1d8 <grep+0x14>
      m = 0;
 294:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 29b:	e9 38 ff ff ff       	jmp    1d8 <grep+0x14>
}
 2a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2a3:	5b                   	pop    %ebx
 2a4:	5e                   	pop    %esi
 2a5:	5f                   	pop    %edi
 2a6:	5d                   	pop    %ebp
 2a7:	c3                   	ret    

000002a8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	53                   	push   %ebx
 2ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b2:	31 c0                	xor    %eax,%eax
 2b4:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 2b7:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2ba:	40                   	inc    %eax
 2bb:	84 d2                	test   %dl,%dl
 2bd:	75 f5                	jne    2b4 <strcpy+0xc>
    ;
  return os;
}
 2bf:	89 c8                	mov    %ecx,%eax
 2c1:	5b                   	pop    %ebx
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    

000002c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	53                   	push   %ebx
 2c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2ce:	0f b6 03             	movzbl (%ebx),%eax
 2d1:	0f b6 0a             	movzbl (%edx),%ecx
 2d4:	84 c0                	test   %al,%al
 2d6:	75 10                	jne    2e8 <strcmp+0x24>
 2d8:	eb 1a                	jmp    2f4 <strcmp+0x30>
 2da:	66 90                	xchg   %ax,%ax
    p++, q++;
 2dc:	43                   	inc    %ebx
 2dd:	42                   	inc    %edx
  while(*p && *p == *q)
 2de:	0f b6 03             	movzbl (%ebx),%eax
 2e1:	0f b6 0a             	movzbl (%edx),%ecx
 2e4:	84 c0                	test   %al,%al
 2e6:	74 0c                	je     2f4 <strcmp+0x30>
 2e8:	38 c8                	cmp    %cl,%al
 2ea:	74 f0                	je     2dc <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2ec:	29 c8                	sub    %ecx,%eax
}
 2ee:	5b                   	pop    %ebx
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d 76 00             	lea    0x0(%esi),%esi
 2f4:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2f6:	29 c8                	sub    %ecx,%eax
}
 2f8:	5b                   	pop    %ebx
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	90                   	nop

000002fc <strlen>:

uint
strlen(const char *s)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 302:	80 3a 00             	cmpb   $0x0,(%edx)
 305:	74 15                	je     31c <strlen+0x20>
 307:	31 c0                	xor    %eax,%eax
 309:	8d 76 00             	lea    0x0(%esi),%esi
 30c:	40                   	inc    %eax
 30d:	89 c1                	mov    %eax,%ecx
 30f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 313:	75 f7                	jne    30c <strlen+0x10>
    ;
  return n;
}
 315:	89 c8                	mov    %ecx,%eax
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 31c:	31 c9                	xor    %ecx,%ecx
}
 31e:	89 c8                	mov    %ecx,%eax
 320:	5d                   	pop    %ebp
 321:	c3                   	ret    
 322:	66 90                	xchg   %ax,%ax

00000324 <memset>:

void*
memset(void *dst, int c, uint n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 328:	8b 7d 08             	mov    0x8(%ebp),%edi
 32b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	fc                   	cld    
 332:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	5f                   	pop    %edi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	66 90                	xchg   %ax,%ax

0000033c <strchr>:

char*
strchr(const char *s, char c)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 345:	8a 10                	mov    (%eax),%dl
 347:	84 d2                	test   %dl,%dl
 349:	75 0c                	jne    357 <strchr+0x1b>
 34b:	eb 13                	jmp    360 <strchr+0x24>
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	40                   	inc    %eax
 351:	8a 10                	mov    (%eax),%dl
 353:	84 d2                	test   %dl,%dl
 355:	74 09                	je     360 <strchr+0x24>
    if(*s == c)
 357:	38 d1                	cmp    %dl,%cl
 359:	75 f5                	jne    350 <strchr+0x14>
      return (char*)s;
  return 0;
}
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 360:	31 c0                	xor    %eax,%eax
}
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    

00000364 <gets>:

char*
gets(char *buf, int max)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36d:	8b 75 08             	mov    0x8(%ebp),%esi
 370:	bb 01 00 00 00       	mov    $0x1,%ebx
 375:	29 f3                	sub    %esi,%ebx
    cc = read(0, &c, 1);
 377:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 37a:	eb 20                	jmp    39c <gets+0x38>
    cc = read(0, &c, 1);
 37c:	50                   	push   %eax
 37d:	6a 01                	push   $0x1
 37f:	57                   	push   %edi
 380:	6a 00                	push   $0x0
 382:	e8 ea 00 00 00       	call   471 <read>
    if(cc < 1)
 387:	83 c4 10             	add    $0x10,%esp
 38a:	85 c0                	test   %eax,%eax
 38c:	7e 16                	jle    3a4 <gets+0x40>
      break;
    buf[i++] = c;
 38e:	8a 45 e7             	mov    -0x19(%ebp),%al
 391:	88 06                	mov    %al,(%esi)
    if(c == '\n' || c == '\r')
 393:	46                   	inc    %esi
 394:	3c 0a                	cmp    $0xa,%al
 396:	74 0c                	je     3a4 <gets+0x40>
 398:	3c 0d                	cmp    $0xd,%al
 39a:	74 08                	je     3a4 <gets+0x40>
  for(i=0; i+1 < max; ){
 39c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 39f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 3a2:	7f d8                	jg     37c <gets+0x18>
      break;
  }
  buf[i] = '\0';
 3a4:	c6 06 00             	movb   $0x0,(%esi)
  return buf;
}
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5f                   	pop    %edi
 3b0:	5d                   	pop    %ebp
 3b1:	c3                   	ret    
 3b2:	66 90                	xchg   %ax,%ax

000003b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	6a 00                	push   $0x0
 3be:	ff 75 08             	pushl  0x8(%ebp)
 3c1:	e8 d3 00 00 00       	call   499 <open>
  if(fd < 0)
 3c6:	83 c4 10             	add    $0x10,%esp
 3c9:	85 c0                	test   %eax,%eax
 3cb:	78 27                	js     3f4 <stat+0x40>
 3cd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3cf:	83 ec 08             	sub    $0x8,%esp
 3d2:	ff 75 0c             	pushl  0xc(%ebp)
 3d5:	50                   	push   %eax
 3d6:	e8 d6 00 00 00       	call   4b1 <fstat>
 3db:	89 c6                	mov    %eax,%esi
  close(fd);
 3dd:	89 1c 24             	mov    %ebx,(%esp)
 3e0:	e8 9c 00 00 00       	call   481 <close>
  return r;
 3e5:	83 c4 10             	add    $0x10,%esp
}
 3e8:	89 f0                	mov    %esi,%eax
 3ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    
 3f1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3f4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3f9:	eb ed                	jmp    3e8 <stat+0x34>
 3fb:	90                   	nop

000003fc <atoi>:

int
atoi(const char *s)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	53                   	push   %ebx
 400:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 403:	0f be 01             	movsbl (%ecx),%eax
 406:	8d 50 d0             	lea    -0x30(%eax),%edx
 409:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 411:	77 16                	ja     429 <atoi+0x2d>
 413:	90                   	nop
    n = n*10 + *s++ - '0';
 414:	41                   	inc    %ecx
 415:	8d 14 92             	lea    (%edx,%edx,4),%edx
 418:	01 d2                	add    %edx,%edx
 41a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 41e:	0f be 01             	movsbl (%ecx),%eax
 421:	8d 58 d0             	lea    -0x30(%eax),%ebx
 424:	80 fb 09             	cmp    $0x9,%bl
 427:	76 eb                	jbe    414 <atoi+0x18>
  return n;
}
 429:	89 d0                	mov    %edx,%eax
 42b:	5b                   	pop    %ebx
 42c:	5d                   	pop    %ebp
 42d:	c3                   	ret    
 42e:	66 90                	xchg   %ax,%ax

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	8b 75 0c             	mov    0xc(%ebp),%esi
 43b:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43e:	85 d2                	test   %edx,%edx
 440:	7e 0b                	jle    44d <memmove+0x1d>
 442:	01 c2                	add    %eax,%edx
  dst = vdst;
 444:	89 c7                	mov    %eax,%edi
 446:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 448:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 449:	39 fa                	cmp    %edi,%edx
 44b:	75 fb                	jne    448 <memmove+0x18>
  return vdst;
}
 44d:	5e                   	pop    %esi
 44e:	5f                   	pop    %edi
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret    

00000451 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 451:	b8 01 00 00 00       	mov    $0x1,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <exit>:
SYSCALL(exit)
 459:	b8 02 00 00 00       	mov    $0x2,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <wait>:
SYSCALL(wait)
 461:	b8 03 00 00 00       	mov    $0x3,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <pipe>:
SYSCALL(pipe)
 469:	b8 04 00 00 00       	mov    $0x4,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <read>:
SYSCALL(read)
 471:	b8 05 00 00 00       	mov    $0x5,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <write>:
SYSCALL(write)
 479:	b8 10 00 00 00       	mov    $0x10,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <close>:
SYSCALL(close)
 481:	b8 15 00 00 00       	mov    $0x15,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <kill>:
SYSCALL(kill)
 489:	b8 06 00 00 00       	mov    $0x6,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <exec>:
SYSCALL(exec)
 491:	b8 07 00 00 00       	mov    $0x7,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <open>:
SYSCALL(open)
 499:	b8 0f 00 00 00       	mov    $0xf,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mknod>:
SYSCALL(mknod)
 4a1:	b8 11 00 00 00       	mov    $0x11,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <unlink>:
SYSCALL(unlink)
 4a9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <fstat>:
SYSCALL(fstat)
 4b1:	b8 08 00 00 00       	mov    $0x8,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <link>:
SYSCALL(link)
 4b9:	b8 13 00 00 00       	mov    $0x13,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mkdir>:
SYSCALL(mkdir)
 4c1:	b8 14 00 00 00       	mov    $0x14,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <chdir>:
SYSCALL(chdir)
 4c9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <dup>:
SYSCALL(dup)
 4d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getpid>:
SYSCALL(getpid)
 4d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sbrk>:
SYSCALL(sbrk)
 4e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sleep>:
SYSCALL(sleep)
 4e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <uptime>:
SYSCALL(uptime)
 4f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <settickets>:
SYSCALL(settickets)
 4f9:	b8 16 00 00 00       	mov    $0x16,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <getpinfo>:
SYSCALL(getpinfo)
 501:	b8 17 00 00 00       	mov    $0x17,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    
 509:	66 90                	xchg   %ax,%ax
 50b:	90                   	nop

0000050c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	57                   	push   %edi
 510:	56                   	push   %esi
 511:	53                   	push   %ebx
 512:	83 ec 3c             	sub    $0x3c,%esp
 515:	89 45 bc             	mov    %eax,-0x44(%ebp)
 518:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 51b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 51d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 520:	85 db                	test   %ebx,%ebx
 522:	74 04                	je     528 <printint+0x1c>
 524:	85 d2                	test   %edx,%edx
 526:	78 68                	js     590 <printint+0x84>
  neg = 0;
 528:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 52f:	31 ff                	xor    %edi,%edi
 531:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 534:	89 c8                	mov    %ecx,%eax
 536:	31 d2                	xor    %edx,%edx
 538:	f7 75 c4             	divl   -0x3c(%ebp)
 53b:	89 fb                	mov    %edi,%ebx
 53d:	8d 7f 01             	lea    0x1(%edi),%edi
 540:	8a 92 e0 08 00 00    	mov    0x8e0(%edx),%dl
 546:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 54a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 54d:	89 c1                	mov    %eax,%ecx
 54f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 552:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 555:	76 dd                	jbe    534 <printint+0x28>
  if(neg)
 557:	8b 4d 08             	mov    0x8(%ebp),%ecx
 55a:	85 c9                	test   %ecx,%ecx
 55c:	74 09                	je     567 <printint+0x5b>
    buf[i++] = '-';
 55e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 563:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 565:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 567:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 56b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 56e:	eb 03                	jmp    573 <printint+0x67>
 570:	8a 13                	mov    (%ebx),%dl
 572:	4b                   	dec    %ebx
    putc(fd, buf[i]);
 573:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 576:	50                   	push   %eax
 577:	6a 01                	push   $0x1
 579:	56                   	push   %esi
 57a:	57                   	push   %edi
 57b:	e8 f9 fe ff ff       	call   479 <write>
  while(--i >= 0)
 580:	83 c4 10             	add    $0x10,%esp
 583:	39 de                	cmp    %ebx,%esi
 585:	75 e9                	jne    570 <printint+0x64>
}
 587:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58a:	5b                   	pop    %ebx
 58b:	5e                   	pop    %esi
 58c:	5f                   	pop    %edi
 58d:	5d                   	pop    %ebp
 58e:	c3                   	ret    
 58f:	90                   	nop
    x = -xx;
 590:	f7 d9                	neg    %ecx
 592:	eb 9b                	jmp    52f <printint+0x23>

00000594 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59d:	8b 75 0c             	mov    0xc(%ebp),%esi
 5a0:	8a 1e                	mov    (%esi),%bl
 5a2:	84 db                	test   %bl,%bl
 5a4:	0f 84 a3 00 00 00    	je     64d <printf+0xb9>
 5aa:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 5ab:	8d 45 10             	lea    0x10(%ebp),%eax
 5ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 5b1:	31 d2                	xor    %edx,%edx
  write(fd, &c, 1);
 5b3:	8d 7d e7             	lea    -0x19(%ebp),%edi
 5b6:	eb 29                	jmp    5e1 <printf+0x4d>
 5b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5bb:	83 f8 25             	cmp    $0x25,%eax
 5be:	0f 84 94 00 00 00    	je     658 <printf+0xc4>
        state = '%';
      } else {
        putc(fd, c);
 5c4:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5c7:	50                   	push   %eax
 5c8:	6a 01                	push   $0x1
 5ca:	57                   	push   %edi
 5cb:	ff 75 08             	pushl  0x8(%ebp)
 5ce:	e8 a6 fe ff ff       	call   479 <write>
        putc(fd, c);
 5d3:	83 c4 10             	add    $0x10,%esp
 5d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 5d9:	46                   	inc    %esi
 5da:	8a 5e ff             	mov    -0x1(%esi),%bl
 5dd:	84 db                	test   %bl,%bl
 5df:	74 6c                	je     64d <printf+0xb9>
    c = fmt[i] & 0xff;
 5e1:	0f be cb             	movsbl %bl,%ecx
 5e4:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5e7:	85 d2                	test   %edx,%edx
 5e9:	74 cd                	je     5b8 <printf+0x24>
      }
    } else if(state == '%'){
 5eb:	83 fa 25             	cmp    $0x25,%edx
 5ee:	75 e9                	jne    5d9 <printf+0x45>
      if(c == 'd'){
 5f0:	83 f8 64             	cmp    $0x64,%eax
 5f3:	0f 84 97 00 00 00    	je     690 <printf+0xfc>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5f9:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5ff:	83 f9 70             	cmp    $0x70,%ecx
 602:	74 60                	je     664 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 604:	83 f8 73             	cmp    $0x73,%eax
 607:	0f 84 8f 00 00 00    	je     69c <printf+0x108>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60d:	83 f8 63             	cmp    $0x63,%eax
 610:	0f 84 d6 00 00 00    	je     6ec <printf+0x158>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 616:	83 f8 25             	cmp    $0x25,%eax
 619:	0f 84 c1 00 00 00    	je     6e0 <printf+0x14c>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 623:	50                   	push   %eax
 624:	6a 01                	push   $0x1
 626:	57                   	push   %edi
 627:	ff 75 08             	pushl  0x8(%ebp)
 62a:	e8 4a fe ff ff       	call   479 <write>
        putc(fd, c);
 62f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 632:	83 c4 0c             	add    $0xc,%esp
 635:	6a 01                	push   $0x1
 637:	57                   	push   %edi
 638:	ff 75 08             	pushl  0x8(%ebp)
 63b:	e8 39 fe ff ff       	call   479 <write>
        putc(fd, c);
 640:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 643:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 645:	46                   	inc    %esi
 646:	8a 5e ff             	mov    -0x1(%esi),%bl
 649:	84 db                	test   %bl,%bl
 64b:	75 94                	jne    5e1 <printf+0x4d>
    }
  }
}
 64d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 650:	5b                   	pop    %ebx
 651:	5e                   	pop    %esi
 652:	5f                   	pop    %edi
 653:	5d                   	pop    %ebp
 654:	c3                   	ret    
 655:	8d 76 00             	lea    0x0(%esi),%esi
        state = '%';
 658:	ba 25 00 00 00       	mov    $0x25,%edx
 65d:	e9 77 ff ff ff       	jmp    5d9 <printf+0x45>
 662:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 664:	83 ec 0c             	sub    $0xc,%esp
 667:	6a 00                	push   $0x0
 669:	b9 10 00 00 00       	mov    $0x10,%ecx
 66e:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 671:	8b 13                	mov    (%ebx),%edx
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	e8 91 fe ff ff       	call   50c <printint>
        ap++;
 67b:	89 d8                	mov    %ebx,%eax
 67d:	83 c0 04             	add    $0x4,%eax
 680:	89 45 d0             	mov    %eax,-0x30(%ebp)
 683:	83 c4 10             	add    $0x10,%esp
      state = 0;
 686:	31 d2                	xor    %edx,%edx
        ap++;
 688:	e9 4c ff ff ff       	jmp    5d9 <printf+0x45>
 68d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	6a 01                	push   $0x1
 695:	b9 0a 00 00 00       	mov    $0xa,%ecx
 69a:	eb d2                	jmp    66e <printf+0xda>
        s = (char*)*ap;
 69c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 69f:	8b 18                	mov    (%eax),%ebx
        ap++;
 6a1:	83 c0 04             	add    $0x4,%eax
 6a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6a7:	85 db                	test   %ebx,%ebx
 6a9:	74 65                	je     710 <printf+0x17c>
        while(*s != 0){
 6ab:	8a 03                	mov    (%ebx),%al
 6ad:	84 c0                	test   %al,%al
 6af:	74 70                	je     721 <printf+0x18d>
 6b1:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6b4:	89 de                	mov    %ebx,%esi
 6b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6b9:	8d 76 00             	lea    0x0(%esi),%esi
          putc(fd, *s);
 6bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6bf:	50                   	push   %eax
 6c0:	6a 01                	push   $0x1
 6c2:	57                   	push   %edi
 6c3:	53                   	push   %ebx
 6c4:	e8 b0 fd ff ff       	call   479 <write>
          s++;
 6c9:	46                   	inc    %esi
        while(*s != 0){
 6ca:	8a 06                	mov    (%esi),%al
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	84 c0                	test   %al,%al
 6d1:	75 e9                	jne    6bc <printf+0x128>
 6d3:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6d6:	31 d2                	xor    %edx,%edx
 6d8:	e9 fc fe ff ff       	jmp    5d9 <printf+0x45>
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 6e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6e3:	52                   	push   %edx
 6e4:	e9 4c ff ff ff       	jmp    635 <printf+0xa1>
 6e9:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, *ap);
 6ec:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6ef:	8b 03                	mov    (%ebx),%eax
 6f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f4:	51                   	push   %ecx
 6f5:	6a 01                	push   $0x1
 6f7:	57                   	push   %edi
 6f8:	ff 75 08             	pushl  0x8(%ebp)
 6fb:	e8 79 fd ff ff       	call   479 <write>
        ap++;
 700:	83 c3 04             	add    $0x4,%ebx
 703:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 706:	83 c4 10             	add    $0x10,%esp
      state = 0;
 709:	31 d2                	xor    %edx,%edx
 70b:	e9 c9 fe ff ff       	jmp    5d9 <printf+0x45>
          s = "(null)";
 710:	bb d6 08 00 00       	mov    $0x8d6,%ebx
        while(*s != 0){
 715:	b0 28                	mov    $0x28,%al
 717:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 71a:	89 de                	mov    %ebx,%esi
 71c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 71f:	eb 9b                	jmp    6bc <printf+0x128>
      state = 0;
 721:	31 d2                	xor    %edx,%edx
 723:	e9 b1 fe ff ff       	jmp    5d9 <printf+0x45>

00000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	57                   	push   %edi
 72c:	56                   	push   %esi
 72d:	53                   	push   %ebx
 72e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 731:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	a1 80 0c 00 00       	mov    0xc80,%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	39 c8                	cmp    %ecx,%eax
 73d:	73 11                	jae    750 <free+0x28>
 73f:	90                   	nop
 740:	39 d1                	cmp    %edx,%ecx
 742:	72 14                	jb     758 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	39 d0                	cmp    %edx,%eax
 746:	73 10                	jae    758 <free+0x30>
{
 748:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	8b 10                	mov    (%eax),%edx
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	72 f0                	jb     740 <free+0x18>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	39 d0                	cmp    %edx,%eax
 752:	72 f4                	jb     748 <free+0x20>
 754:	39 d1                	cmp    %edx,%ecx
 756:	73 f0                	jae    748 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 fa                	cmp    %edi,%edx
 760:	74 1a                	je     77c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 762:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76b:	39 f1                	cmp    %esi,%ecx
 76d:	74 24                	je     793 <free+0x6b>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 76f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 771:	a3 80 0c 00 00       	mov    %eax,0xc80
}
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
 77b:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 77c:	03 72 04             	add    0x4(%edx),%esi
 77f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 12                	mov    (%edx),%edx
 786:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 789:	8b 50 04             	mov    0x4(%eax),%edx
 78c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 78f:	39 f1                	cmp    %esi,%ecx
 791:	75 dc                	jne    76f <free+0x47>
    p->s.size += bp->s.size;
 793:	03 53 fc             	add    -0x4(%ebx),%edx
 796:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 799:	8b 53 f8             	mov    -0x8(%ebx),%edx
 79c:	89 10                	mov    %edx,(%eax)
  freep = p;
 79e:	a3 80 0c 00 00       	mov    %eax,0xc80
}
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    

000007a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	57                   	push   %edi
 7ac:	56                   	push   %esi
 7ad:	53                   	push   %ebx
 7ae:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b1:	8b 45 08             	mov    0x8(%ebp),%eax
 7b4:	8d 70 07             	lea    0x7(%eax),%esi
 7b7:	c1 ee 03             	shr    $0x3,%esi
 7ba:	46                   	inc    %esi
  if((prevp = freep) == 0){
 7bb:	8b 3d 80 0c 00 00    	mov    0xc80,%edi
 7c1:	85 ff                	test   %edi,%edi
 7c3:	0f 84 a3 00 00 00    	je     86c <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c9:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 7cb:	8b 48 04             	mov    0x4(%eax),%ecx
 7ce:	39 f1                	cmp    %esi,%ecx
 7d0:	73 67                	jae    839 <malloc+0x91>
 7d2:	89 f3                	mov    %esi,%ebx
 7d4:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7da:	0f 82 80 00 00 00    	jb     860 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 7e0:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7ea:	eb 11                	jmp    7fd <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7ee:	8b 4a 04             	mov    0x4(%edx),%ecx
 7f1:	39 f1                	cmp    %esi,%ecx
 7f3:	73 4b                	jae    840 <malloc+0x98>
 7f5:	8b 3d 80 0c 00 00    	mov    0xc80,%edi
 7fb:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fd:	39 c7                	cmp    %eax,%edi
 7ff:	75 eb                	jne    7ec <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 801:	83 ec 0c             	sub    $0xc,%esp
 804:	ff 75 e4             	pushl  -0x1c(%ebp)
 807:	e8 d5 fc ff ff       	call   4e1 <sbrk>
  if(p == (char*)-1)
 80c:	83 c4 10             	add    $0x10,%esp
 80f:	83 f8 ff             	cmp    $0xffffffff,%eax
 812:	74 1b                	je     82f <malloc+0x87>
  hp->s.size = nu;
 814:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 817:	83 ec 0c             	sub    $0xc,%esp
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	50                   	push   %eax
 81e:	e8 05 ff ff ff       	call   728 <free>
  return freep;
 823:	a1 80 0c 00 00       	mov    0xc80,%eax
      if((p = morecore(nunits)) == 0)
 828:	83 c4 10             	add    $0x10,%esp
 82b:	85 c0                	test   %eax,%eax
 82d:	75 bd                	jne    7ec <malloc+0x44>
        return 0;
 82f:	31 c0                	xor    %eax,%eax
  }
}
 831:	8d 65 f4             	lea    -0xc(%ebp),%esp
 834:	5b                   	pop    %ebx
 835:	5e                   	pop    %esi
 836:	5f                   	pop    %edi
 837:	5d                   	pop    %ebp
 838:	c3                   	ret    
    if(p->s.size >= nunits){
 839:	89 c2                	mov    %eax,%edx
 83b:	89 f8                	mov    %edi,%eax
 83d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 840:	39 ce                	cmp    %ecx,%esi
 842:	74 54                	je     898 <malloc+0xf0>
        p->s.size -= nunits;
 844:	29 f1                	sub    %esi,%ecx
 846:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 849:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 84c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 84f:	a3 80 0c 00 00       	mov    %eax,0xc80
      return (void*)(p + 1);
 854:	8d 42 08             	lea    0x8(%edx),%eax
}
 857:	8d 65 f4             	lea    -0xc(%ebp),%esp
 85a:	5b                   	pop    %ebx
 85b:	5e                   	pop    %esi
 85c:	5f                   	pop    %edi
 85d:	5d                   	pop    %ebp
 85e:	c3                   	ret    
 85f:	90                   	nop
 860:	bb 00 10 00 00       	mov    $0x1000,%ebx
 865:	e9 76 ff ff ff       	jmp    7e0 <malloc+0x38>
 86a:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 86c:	c7 05 80 0c 00 00 84 	movl   $0xc84,0xc80
 873:	0c 00 00 
 876:	c7 05 84 0c 00 00 84 	movl   $0xc84,0xc84
 87d:	0c 00 00 
    base.s.size = 0;
 880:	c7 05 88 0c 00 00 00 	movl   $0x0,0xc88
 887:	00 00 00 
 88a:	bf 84 0c 00 00       	mov    $0xc84,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88f:	89 f8                	mov    %edi,%eax
 891:	e9 3c ff ff ff       	jmp    7d2 <malloc+0x2a>
 896:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 898:	8b 0a                	mov    (%edx),%ecx
 89a:	89 08                	mov    %ecx,(%eax)
 89c:	eb b1                	jmp    84f <malloc+0xa7>
