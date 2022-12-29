
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f8 2a 10 80       	mov    $0x80102af8,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 40 68 10 80       	push   $0x80106840
80100040:	68 c0 b5 10 80       	push   $0x8010b5c0
80100045:	e8 f2 3e 00 00       	call   80103f3c <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100051:	fc 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010005b:	fc 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
80100061:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100066:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
8010006b:	eb 05                	jmp    80100072 <binit+0x3e>
8010006d:	8d 76 00             	lea    0x0(%esi),%esi
80100070:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100072:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100075:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010007c:	83 ec 08             	sub    $0x8,%esp
8010007f:	68 47 68 10 80       	push   $0x80106847
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 9f 3d 00 00       	call   80103e2c <initsleeplock>
    bcache.head.next->prev = b;
8010008d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100092:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100095:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009b:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a1:	89 d8                	mov    %ebx,%eax
801000a3:	83 c4 10             	add    $0x10,%esp
801000a6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000ac:	75 c2                	jne    80100070 <binit+0x3c>
  }
}
801000ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	90                   	nop

801000b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	57                   	push   %edi
801000b8:	56                   	push   %esi
801000b9:	53                   	push   %ebx
801000ba:	83 ec 18             	sub    $0x18,%esp
801000bd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000c3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c8:	e8 af 3f 00 00       	call   8010407c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cd:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000d3:	83 c4 10             	add    $0x10,%esp
801000d6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000dc:	75 0d                	jne    801000eb <bread+0x37>
801000de:	eb 1c                	jmp    801000fc <bread+0x48>
801000e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000e3:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000e9:	74 11                	je     801000fc <bread+0x48>
    if(b->dev == dev && b->blockno == blockno){
801000eb:	3b 7b 04             	cmp    0x4(%ebx),%edi
801000ee:	75 f0                	jne    801000e0 <bread+0x2c>
801000f0:	3b 73 08             	cmp    0x8(%ebx),%esi
801000f3:	75 eb                	jne    801000e0 <bread+0x2c>
      b->refcnt++;
801000f5:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
801000f8:	eb 3c                	jmp    80100136 <bread+0x82>
801000fa:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000fc:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100102:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100108:	75 0d                	jne    80100117 <bread+0x63>
8010010a:	eb 6c                	jmp    80100178 <bread+0xc4>
8010010c:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010010f:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100115:	74 61                	je     80100178 <bread+0xc4>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100117:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010011a:	85 c0                	test   %eax,%eax
8010011c:	75 ee                	jne    8010010c <bread+0x58>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 e9                	jne    8010010c <bread+0x58>
      b->dev = dev;
80100123:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	83 ec 0c             	sub    $0xc,%esp
80100139:	68 c0 b5 10 80       	push   $0x8010b5c0
8010013e:	e8 d1 3f 00 00       	call   80104114 <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 12 3d 00 00       	call   80103e60 <acquiresleep>
      return b;
8010014e:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100151:	f6 03 02             	testb  $0x2,(%ebx)
80100154:	74 0a                	je     80100160 <bread+0xac>
    iderw(b);
  }
  return b;
}
80100156:	89 d8                	mov    %ebx,%eax
80100158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010015b:	5b                   	pop    %ebx
8010015c:	5e                   	pop    %esi
8010015d:	5f                   	pop    %edi
8010015e:	5d                   	pop    %ebp
8010015f:	c3                   	ret    
    iderw(b);
80100160:	83 ec 0c             	sub    $0xc,%esp
80100163:	53                   	push   %ebx
80100164:	e8 83 1d 00 00       	call   80101eec <iderw>
80100169:	83 c4 10             	add    $0x10,%esp
}
8010016c:	89 d8                	mov    %ebx,%eax
8010016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100171:	5b                   	pop    %ebx
80100172:	5e                   	pop    %esi
80100173:	5f                   	pop    %edi
80100174:	5d                   	pop    %ebp
80100175:	c3                   	ret    
80100176:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	68 4e 68 10 80       	push   $0x8010684e
80100180:	e8 bb 01 00 00       	call   80100340 <panic>
80100185:	8d 76 00             	lea    0x0(%esi),%esi

80100188 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100188:	55                   	push   %ebp
80100189:	89 e5                	mov    %esp,%ebp
8010018b:	53                   	push   %ebx
8010018c:	83 ec 10             	sub    $0x10,%esp
8010018f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100192:	8d 43 0c             	lea    0xc(%ebx),%eax
80100195:	50                   	push   %eax
80100196:	e8 55 3d 00 00       	call   80103ef0 <holdingsleep>
8010019b:	83 c4 10             	add    $0x10,%esp
8010019e:	85 c0                	test   %eax,%eax
801001a0:	74 0f                	je     801001b1 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a2:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001ab:	c9                   	leave  
  iderw(b);
801001ac:	e9 3b 1d 00 00       	jmp    80101eec <iderw>
    panic("bwrite");
801001b1:	83 ec 0c             	sub    $0xc,%esp
801001b4:	68 5f 68 10 80       	push   $0x8010685f
801001b9:	e8 82 01 00 00       	call   80100340 <panic>
801001be:	66 90                	xchg   %ax,%ax

801001c0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	56                   	push   %esi
801001c4:	53                   	push   %ebx
801001c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cb:	83 ec 0c             	sub    $0xc,%esp
801001ce:	56                   	push   %esi
801001cf:	e8 1c 3d 00 00       	call   80103ef0 <holdingsleep>
801001d4:	83 c4 10             	add    $0x10,%esp
801001d7:	85 c0                	test   %eax,%eax
801001d9:	74 64                	je     8010023f <brelse+0x7f>
    panic("brelse");

  releasesleep(&b->lock);
801001db:	83 ec 0c             	sub    $0xc,%esp
801001de:	56                   	push   %esi
801001df:	e8 d0 3c 00 00       	call   80103eb4 <releasesleep>

  acquire(&bcache.lock);
801001e4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801001eb:	e8 8c 3e 00 00       	call   8010407c <acquire>
  b->refcnt--;
801001f0:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f3:	48                   	dec    %eax
801001f4:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	75 2f                	jne    8010022d <brelse+0x6d>
    // no one is waiting for it.
    b->next->prev = b->prev;
801001fe:	8b 43 54             	mov    0x54(%ebx),%eax
80100201:	8b 53 50             	mov    0x50(%ebx),%edx
80100204:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100207:	8b 43 50             	mov    0x50(%ebx),%eax
8010020a:	8b 53 54             	mov    0x54(%ebx),%edx
8010020d:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100210:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100215:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100218:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
8010021f:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100224:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100227:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010022d:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100234:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100237:	5b                   	pop    %ebx
80100238:	5e                   	pop    %esi
80100239:	5d                   	pop    %ebp
  release(&bcache.lock);
8010023a:	e9 d5 3e 00 00       	jmp    80104114 <release>
    panic("brelse");
8010023f:	83 ec 0c             	sub    $0xc,%esp
80100242:	68 66 68 10 80       	push   $0x80106866
80100247:	e8 f4 00 00 00       	call   80100340 <panic>

8010024c <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
8010024c:	55                   	push   %ebp
8010024d:	89 e5                	mov    %esp,%ebp
8010024f:	57                   	push   %edi
80100250:	56                   	push   %esi
80100251:	53                   	push   %ebx
80100252:	83 ec 18             	sub    $0x18,%esp
80100255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100258:	ff 75 08             	pushl  0x8(%ebp)
8010025b:	e8 c4 13 00 00       	call   80101624 <iunlock>
  target = n;
80100260:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
80100262:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100269:	e8 0e 3e 00 00       	call   8010407c <acquire>
  while(n > 0){
8010026e:	83 c4 10             	add    $0x10,%esp
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100271:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100274:	01 df                	add    %ebx,%edi
  while(n > 0){
80100276:	85 db                	test   %ebx,%ebx
80100278:	0f 8e 91 00 00 00    	jle    8010030f <consoleread+0xc3>
    while(input.r == input.w){
8010027e:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100283:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100289:	74 27                	je     801002b2 <consoleread+0x66>
8010028b:	eb 57                	jmp    801002e4 <consoleread+0x98>
8010028d:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
80100290:	83 ec 08             	sub    $0x8,%esp
80100293:	68 20 a5 10 80       	push   $0x8010a520
80100298:	68 a0 ff 10 80       	push   $0x8010ffa0
8010029d:	e8 72 37 00 00       	call   80103a14 <sleep>
    while(input.r == input.w){
801002a2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a7:	83 c4 10             	add    $0x10,%esp
801002aa:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b0:	75 32                	jne    801002e4 <consoleread+0x98>
      if(myproc()->killed){
801002b2:	e8 ad 30 00 00       	call   80103364 <myproc>
801002b7:	8b 48 2c             	mov    0x2c(%eax),%ecx
801002ba:	85 c9                	test   %ecx,%ecx
801002bc:	74 d2                	je     80100290 <consoleread+0x44>
        release(&cons.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 20 a5 10 80       	push   $0x8010a520
801002c6:	e8 49 3e 00 00       	call   80104114 <release>
        ilock(ip);
801002cb:	5a                   	pop    %edx
801002cc:	ff 75 08             	pushl  0x8(%ebp)
801002cf:	e8 88 12 00 00       	call   8010155c <ilock>
        return -1;
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002df:	5b                   	pop    %ebx
801002e0:	5e                   	pop    %esi
801002e1:	5f                   	pop    %edi
801002e2:	5d                   	pop    %ebp
801002e3:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002e4:	8d 50 01             	lea    0x1(%eax),%edx
801002e7:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002ed:	89 c2                	mov    %eax,%edx
801002ef:	83 e2 7f             	and    $0x7f,%edx
801002f2:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
801002f9:	80 f9 04             	cmp    $0x4,%cl
801002fc:	74 36                	je     80100334 <consoleread+0xe8>
    *dst++ = c;
801002fe:	89 d8                	mov    %ebx,%eax
80100300:	f7 d8                	neg    %eax
80100302:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    --n;
80100305:	4b                   	dec    %ebx
    if(c == '\n')
80100306:	83 f9 0a             	cmp    $0xa,%ecx
80100309:	0f 85 67 ff ff ff    	jne    80100276 <consoleread+0x2a>
  release(&cons.lock);
8010030f:	83 ec 0c             	sub    $0xc,%esp
80100312:	68 20 a5 10 80       	push   $0x8010a520
80100317:	e8 f8 3d 00 00       	call   80104114 <release>
  ilock(ip);
8010031c:	58                   	pop    %eax
8010031d:	ff 75 08             	pushl  0x8(%ebp)
80100320:	e8 37 12 00 00       	call   8010155c <ilock>
  return target - n;
80100325:	89 f0                	mov    %esi,%eax
80100327:	29 d8                	sub    %ebx,%eax
80100329:	83 c4 10             	add    $0x10,%esp
}
8010032c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret    
      if(n < target){
80100334:	39 f3                	cmp    %esi,%ebx
80100336:	73 d7                	jae    8010030f <consoleread+0xc3>
        input.r--;
80100338:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010033d:	eb d0                	jmp    8010030f <consoleread+0xc3>
8010033f:	90                   	nop

80100340 <panic>:
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	56                   	push   %esi
80100344:	53                   	push   %ebx
80100345:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100348:	fa                   	cli    
  cons.locking = 0;
80100349:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100350:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100353:	e8 04 21 00 00       	call   8010245c <lapicid>
80100358:	83 ec 08             	sub    $0x8,%esp
8010035b:	50                   	push   %eax
8010035c:	68 6d 68 10 80       	push   $0x8010686d
80100361:	e8 ba 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
80100366:	58                   	pop    %eax
80100367:	ff 75 08             	pushl  0x8(%ebp)
8010036a:	e8 b1 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
8010036f:	c7 04 24 df 71 10 80 	movl   $0x801071df,(%esp)
80100376:	e8 a5 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
8010037b:	5a                   	pop    %edx
8010037c:	59                   	pop    %ecx
8010037d:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100380:	53                   	push   %ebx
80100381:	8d 45 08             	lea    0x8(%ebp),%eax
80100384:	50                   	push   %eax
80100385:	e8 ce 3b 00 00       	call   80103f58 <getcallerpcs>
  for(i=0; i<10; i++)
8010038a:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010038d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100390:	83 ec 08             	sub    $0x8,%esp
80100393:	ff 33                	pushl  (%ebx)
80100395:	68 81 68 10 80       	push   $0x80106881
8010039a:	e8 81 02 00 00       	call   80100620 <cprintf>
  for(i=0; i<10; i++)
8010039f:	83 c3 04             	add    $0x4,%ebx
801003a2:	83 c4 10             	add    $0x10,%esp
801003a5:	39 f3                	cmp    %esi,%ebx
801003a7:	75 e7                	jne    80100390 <panic+0x50>
  panicked = 1; // freeze other CPU
801003a9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003b0:	00 00 00 
  for(;;)
801003b3:	eb fe                	jmp    801003b3 <panic+0x73>
801003b5:	8d 76 00             	lea    0x0(%esi),%esi

801003b8 <consputc.part.0>:
consputc(int c)
801003b8:	55                   	push   %ebp
801003b9:	89 e5                	mov    %esp,%ebp
801003bb:	57                   	push   %edi
801003bc:	56                   	push   %esi
801003bd:	53                   	push   %ebx
801003be:	83 ec 1c             	sub    $0x1c,%esp
801003c1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003c3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003c8:	0f 84 ce 00 00 00    	je     8010049c <consputc.part.0+0xe4>
    uartputc(c);
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	50                   	push   %eax
801003d2:	e8 49 51 00 00       	call   80105520 <uartputc>
801003d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003da:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003df:	b0 0e                	mov    $0xe,%al
801003e1:	89 ca                	mov    %ecx,%edx
801003e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e4:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003e9:	89 da                	mov    %ebx,%edx
801003eb:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003ec:	0f b6 f8             	movzbl %al,%edi
801003ef:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f2:	b0 0f                	mov    $0xf,%al
801003f4:	89 ca                	mov    %ecx,%edx
801003f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f7:	89 da                	mov    %ebx,%edx
801003f9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003fa:	0f b6 c8             	movzbl %al,%ecx
801003fd:	09 f9                	or     %edi,%ecx
  if(c == '\n')
801003ff:	83 fe 0a             	cmp    $0xa,%esi
80100402:	0f 84 84 00 00 00    	je     8010048c <consputc.part.0+0xd4>
  else if(c == BACKSPACE){
80100408:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010040e:	74 6c                	je     8010047c <consputc.part.0+0xc4>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100410:	8d 59 01             	lea    0x1(%ecx),%ebx
80100413:	89 f0                	mov    %esi,%eax
80100415:	0f b6 f0             	movzbl %al,%esi
80100418:	81 ce 00 07 00 00    	or     $0x700,%esi
8010041e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100425:	80 
  if(pos < 0 || pos > 25*80)
80100426:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010042c:	0f 8f ee 00 00 00    	jg     80100520 <consputc.part.0+0x168>
  if((pos/80) >= 24){  // Scroll up.
80100432:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100438:	0f 8f 8a 00 00 00    	jg     801004c8 <consputc.part.0+0x110>
8010043e:	0f b6 c7             	movzbl %bh,%eax
80100441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100444:	89 de                	mov    %ebx,%esi
80100446:	01 db                	add    %ebx,%ebx
80100448:	8d bb 00 80 0b 80    	lea    -0x7ff48000(%ebx),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044e:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100453:	b0 0e                	mov    $0xe,%al
80100455:	89 da                	mov    %ebx,%edx
80100457:	ee                   	out    %al,(%dx)
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	8a 45 e4             	mov    -0x1c(%ebp),%al
80100460:	89 ca                	mov    %ecx,%edx
80100462:	ee                   	out    %al,(%dx)
80100463:	b0 0f                	mov    $0xf,%al
80100465:	89 da                	mov    %ebx,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 f0                	mov    %esi,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 07 20 07       	movw   $0x720,(%edi)
}
80100472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100475:	5b                   	pop    %ebx
80100476:	5e                   	pop    %esi
80100477:	5f                   	pop    %edi
80100478:	5d                   	pop    %ebp
80100479:	c3                   	ret    
8010047a:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
8010047c:	85 c9                	test   %ecx,%ecx
8010047e:	0f 84 8c 00 00 00    	je     80100510 <consputc.part.0+0x158>
80100484:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100487:	eb 9d                	jmp    80100426 <consputc.part.0+0x6e>
80100489:	8d 76 00             	lea    0x0(%esi),%esi
    pos += 80 - pos%80;
8010048c:	bb 50 00 00 00       	mov    $0x50,%ebx
80100491:	89 c8                	mov    %ecx,%eax
80100493:	99                   	cltd   
80100494:	f7 fb                	idiv   %ebx
80100496:	29 d3                	sub    %edx,%ebx
80100498:	01 cb                	add    %ecx,%ebx
8010049a:	eb 8a                	jmp    80100426 <consputc.part.0+0x6e>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010049c:	83 ec 0c             	sub    $0xc,%esp
8010049f:	6a 08                	push   $0x8
801004a1:	e8 7a 50 00 00       	call   80105520 <uartputc>
801004a6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004ad:	e8 6e 50 00 00       	call   80105520 <uartputc>
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 62 50 00 00       	call   80105520 <uartputc>
801004be:	83 c4 10             	add    $0x10,%esp
801004c1:	e9 14 ff ff ff       	jmp    801003da <consputc.part.0+0x22>
801004c6:	66 90                	xchg   %ax,%ax
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004c8:	50                   	push   %eax
801004c9:	68 60 0e 00 00       	push   $0xe60
801004ce:	68 a0 80 0b 80       	push   $0x800b80a0
801004d3:	68 00 80 0b 80       	push   $0x800b8000
801004d8:	e8 03 3d 00 00       	call   801041e0 <memmove>
    pos -= 80;
801004dd:	8d 73 b0             	lea    -0x50(%ebx),%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e0:	8d 84 1b 60 ff ff ff 	lea    -0xa0(%ebx,%ebx,1),%eax
801004e7:	8d b8 00 80 0b 80    	lea    -0x7ff48000(%eax),%edi
801004ed:	83 c4 0c             	add    $0xc,%esp
801004f0:	b8 80 07 00 00       	mov    $0x780,%eax
801004f5:	29 f0                	sub    %esi,%eax
801004f7:	01 c0                	add    %eax,%eax
801004f9:	50                   	push   %eax
801004fa:	6a 00                	push   $0x0
801004fc:	57                   	push   %edi
801004fd:	e8 5a 3c 00 00       	call   8010415c <memset>
80100502:	83 c4 10             	add    $0x10,%esp
80100505:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
80100509:	e9 40 ff ff ff       	jmp    8010044e <consputc.part.0+0x96>
8010050e:	66 90                	xchg   %ax,%ax
80100510:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80100515:	31 f6                	xor    %esi,%esi
80100517:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010051b:	e9 2e ff ff ff       	jmp    8010044e <consputc.part.0+0x96>
    panic("pos under/overflow");
80100520:	83 ec 0c             	sub    $0xc,%esp
80100523:	68 85 68 10 80       	push   $0x80106885
80100528:	e8 13 fe ff ff       	call   80100340 <panic>
8010052d:	8d 76 00             	lea    0x0(%esi),%esi

80100530 <printint>:
{
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	57                   	push   %edi
80100534:	56                   	push   %esi
80100535:	53                   	push   %ebx
80100536:	83 ec 2c             	sub    $0x2c,%esp
80100539:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010053c:	85 c9                	test   %ecx,%ecx
8010053e:	74 04                	je     80100544 <printint+0x14>
80100540:	85 c0                	test   %eax,%eax
80100542:	78 5e                	js     801005a2 <printint+0x72>
    x = xx;
80100544:	89 c1                	mov    %eax,%ecx
80100546:	31 db                	xor    %ebx,%ebx
  i = 0;
80100548:	31 ff                	xor    %edi,%edi
    buf[i++] = digits[x % base];
8010054a:	89 c8                	mov    %ecx,%eax
8010054c:	31 d2                	xor    %edx,%edx
8010054e:	f7 75 d4             	divl   -0x2c(%ebp)
80100551:	89 fe                	mov    %edi,%esi
80100553:	8d 7f 01             	lea    0x1(%edi),%edi
80100556:	8a 92 b0 68 10 80    	mov    -0x7fef9750(%edx),%dl
8010055c:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
80100560:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80100563:	89 c1                	mov    %eax,%ecx
80100565:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100568:	39 45 d0             	cmp    %eax,-0x30(%ebp)
8010056b:	73 dd                	jae    8010054a <printint+0x1a>
  if(sign)
8010056d:	85 db                	test   %ebx,%ebx
8010056f:	74 09                	je     8010057a <printint+0x4a>
    buf[i++] = '-';
80100571:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
80100576:	89 fe                	mov    %edi,%esi
    buf[i++] = '-';
80100578:	b2 2d                	mov    $0x2d,%dl
  while(--i >= 0)
8010057a:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010057e:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100581:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100587:	85 d2                	test   %edx,%edx
80100589:	74 05                	je     80100590 <printint+0x60>
  asm volatile("cli");
8010058b:	fa                   	cli    
    for(;;)
8010058c:	eb fe                	jmp    8010058c <printint+0x5c>
8010058e:	66 90                	xchg   %ax,%ax
80100590:	e8 23 fe ff ff       	call   801003b8 <consputc.part.0>
  while(--i >= 0)
80100595:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100598:	39 c3                	cmp    %eax,%ebx
8010059a:	74 0e                	je     801005aa <printint+0x7a>
8010059c:	0f be 03             	movsbl (%ebx),%eax
8010059f:	4b                   	dec    %ebx
801005a0:	eb df                	jmp    80100581 <printint+0x51>
801005a2:	89 cb                	mov    %ecx,%ebx
    x = -xx;
801005a4:	f7 d8                	neg    %eax
801005a6:	89 c1                	mov    %eax,%ecx
801005a8:	eb 9e                	jmp    80100548 <printint+0x18>
}
801005aa:	83 c4 2c             	add    $0x2c,%esp
801005ad:	5b                   	pop    %ebx
801005ae:	5e                   	pop    %esi
801005af:	5f                   	pop    %edi
801005b0:	5d                   	pop    %ebp
801005b1:	c3                   	ret    
801005b2:	66 90                	xchg   %ax,%ax

801005b4 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b4:	55                   	push   %ebp
801005b5:	89 e5                	mov    %esp,%ebp
801005b7:	57                   	push   %edi
801005b8:	56                   	push   %esi
801005b9:	53                   	push   %ebx
801005ba:	83 ec 18             	sub    $0x18,%esp
801005bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
801005c0:	ff 75 08             	pushl  0x8(%ebp)
801005c3:	e8 5c 10 00 00       	call   80101624 <iunlock>
  acquire(&cons.lock);
801005c8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005cf:	e8 a8 3a 00 00       	call   8010407c <acquire>
  for(i = 0; i < n; i++)
801005d4:	83 c4 10             	add    $0x10,%esp
801005d7:	85 ff                	test   %edi,%edi
801005d9:	7e 22                	jle    801005fd <consolewrite+0x49>
801005db:	8b 75 0c             	mov    0xc(%ebp),%esi
801005de:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
  if(panicked){
801005e1:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801005e7:	85 d2                	test   %edx,%edx
801005e9:	74 05                	je     801005f0 <consolewrite+0x3c>
801005eb:	fa                   	cli    
    for(;;)
801005ec:	eb fe                	jmp    801005ec <consolewrite+0x38>
801005ee:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
801005f0:	0f b6 06             	movzbl (%esi),%eax
801005f3:	e8 c0 fd ff ff       	call   801003b8 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f8:	46                   	inc    %esi
801005f9:	39 f3                	cmp    %esi,%ebx
801005fb:	75 e4                	jne    801005e1 <consolewrite+0x2d>
  release(&cons.lock);
801005fd:	83 ec 0c             	sub    $0xc,%esp
80100600:	68 20 a5 10 80       	push   $0x8010a520
80100605:	e8 0a 3b 00 00       	call   80104114 <release>
  ilock(ip);
8010060a:	58                   	pop    %eax
8010060b:	ff 75 08             	pushl  0x8(%ebp)
8010060e:	e8 49 0f 00 00       	call   8010155c <ilock>

  return n;
}
80100613:	89 f8                	mov    %edi,%eax
80100615:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100618:	5b                   	pop    %ebx
80100619:	5e                   	pop    %esi
8010061a:	5f                   	pop    %edi
8010061b:	5d                   	pop    %ebp
8010061c:	c3                   	ret    
8010061d:	8d 76 00             	lea    0x0(%esi),%esi

80100620 <cprintf>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100629:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010062e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100631:	85 c0                	test   %eax,%eax
80100633:	0f 85 dc 00 00 00    	jne    80100715 <cprintf+0xf5>
  if (fmt == 0)
80100639:	8b 75 08             	mov    0x8(%ebp),%esi
8010063c:	85 f6                	test   %esi,%esi
8010063e:	0f 84 49 01 00 00    	je     8010078d <cprintf+0x16d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100644:	0f b6 06             	movzbl (%esi),%eax
80100647:	85 c0                	test   %eax,%eax
80100649:	74 35                	je     80100680 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
8010064b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(c != '%'){
80100655:	83 f8 25             	cmp    $0x25,%eax
80100658:	74 3a                	je     80100694 <cprintf+0x74>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	74 09                	je     8010066d <cprintf+0x4d>
80100664:	fa                   	cli    
    for(;;)
80100665:	eb fe                	jmp    80100665 <cprintf+0x45>
80100667:	90                   	nop
80100668:	b8 25 00 00 00       	mov    $0x25,%eax
8010066d:	e8 46 fd ff ff       	call   801003b8 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100672:	ff 45 e4             	incl   -0x1c(%ebp)
80100675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100678:	0f b6 04 06          	movzbl (%esi,%eax,1),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	75 d5                	jne    80100655 <cprintf+0x35>
  if(locking)
80100680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100683:	85 c0                	test   %eax,%eax
80100685:	0f 85 ed 00 00 00    	jne    80100778 <cprintf+0x158>
}
8010068b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010068e:	5b                   	pop    %ebx
8010068f:	5e                   	pop    %esi
80100690:	5f                   	pop    %edi
80100691:	5d                   	pop    %ebp
80100692:	c3                   	ret    
80100693:	90                   	nop
    c = fmt[++i] & 0xff;
80100694:	ff 45 e4             	incl   -0x1c(%ebp)
80100697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010069a:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
    if(c == 0)
8010069e:	85 ff                	test   %edi,%edi
801006a0:	74 de                	je     80100680 <cprintf+0x60>
    switch(c){
801006a2:	83 ff 70             	cmp    $0x70,%edi
801006a5:	74 56                	je     801006fd <cprintf+0xdd>
801006a7:	7f 2a                	jg     801006d3 <cprintf+0xb3>
801006a9:	83 ff 25             	cmp    $0x25,%edi
801006ac:	0f 84 8c 00 00 00    	je     8010073e <cprintf+0x11e>
801006b2:	83 ff 64             	cmp    $0x64,%edi
801006b5:	0f 85 95 00 00 00    	jne    80100750 <cprintf+0x130>
      printint(*argp++, 10, 1);
801006bb:	8d 7b 04             	lea    0x4(%ebx),%edi
801006be:	b9 01 00 00 00       	mov    $0x1,%ecx
801006c3:	ba 0a 00 00 00       	mov    $0xa,%edx
801006c8:	8b 03                	mov    (%ebx),%eax
801006ca:	e8 61 fe ff ff       	call   80100530 <printint>
801006cf:	89 fb                	mov    %edi,%ebx
      break;
801006d1:	eb 9f                	jmp    80100672 <cprintf+0x52>
    switch(c){
801006d3:	83 ff 73             	cmp    $0x73,%edi
801006d6:	75 20                	jne    801006f8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
801006d8:	8d 7b 04             	lea    0x4(%ebx),%edi
801006db:	8b 1b                	mov    (%ebx),%ebx
801006dd:	85 db                	test   %ebx,%ebx
801006df:	75 4f                	jne    80100730 <cprintf+0x110>
        s = "(null)";
801006e1:	bb 98 68 10 80       	mov    $0x80106898,%ebx
      for(; *s; s++)
801006e6:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
801006eb:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801006f1:	85 d2                	test   %edx,%edx
801006f3:	74 35                	je     8010072a <cprintf+0x10a>
801006f5:	fa                   	cli    
    for(;;)
801006f6:	eb fe                	jmp    801006f6 <cprintf+0xd6>
    switch(c){
801006f8:	83 ff 78             	cmp    $0x78,%edi
801006fb:	75 53                	jne    80100750 <cprintf+0x130>
      printint(*argp++, 16, 0);
801006fd:	8d 7b 04             	lea    0x4(%ebx),%edi
80100700:	31 c9                	xor    %ecx,%ecx
80100702:	ba 10 00 00 00       	mov    $0x10,%edx
80100707:	8b 03                	mov    (%ebx),%eax
80100709:	e8 22 fe ff ff       	call   80100530 <printint>
8010070e:	89 fb                	mov    %edi,%ebx
      break;
80100710:	e9 5d ff ff ff       	jmp    80100672 <cprintf+0x52>
    acquire(&cons.lock);
80100715:	83 ec 0c             	sub    $0xc,%esp
80100718:	68 20 a5 10 80       	push   $0x8010a520
8010071d:	e8 5a 39 00 00       	call   8010407c <acquire>
80100722:	83 c4 10             	add    $0x10,%esp
80100725:	e9 0f ff ff ff       	jmp    80100639 <cprintf+0x19>
8010072a:	e8 89 fc ff ff       	call   801003b8 <consputc.part.0>
      for(; *s; s++)
8010072f:	43                   	inc    %ebx
80100730:	0f be 03             	movsbl (%ebx),%eax
80100733:	84 c0                	test   %al,%al
80100735:	75 b4                	jne    801006eb <cprintf+0xcb>
      if((s = (char*)*argp++) == 0)
80100737:	89 fb                	mov    %edi,%ebx
80100739:	e9 34 ff ff ff       	jmp    80100672 <cprintf+0x52>
  if(panicked){
8010073e:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
80100744:	85 ff                	test   %edi,%edi
80100746:	0f 84 1c ff ff ff    	je     80100668 <cprintf+0x48>
8010074c:	fa                   	cli    
    for(;;)
8010074d:	eb fe                	jmp    8010074d <cprintf+0x12d>
8010074f:	90                   	nop
  if(panicked){
80100750:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	74 06                	je     80100760 <cprintf+0x140>
8010075a:	fa                   	cli    
    for(;;)
8010075b:	eb fe                	jmp    8010075b <cprintf+0x13b>
8010075d:	8d 76 00             	lea    0x0(%esi),%esi
80100760:	b8 25 00 00 00       	mov    $0x25,%eax
80100765:	e8 4e fc ff ff       	call   801003b8 <consputc.part.0>
  if(panicked){
8010076a:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100770:	85 d2                	test   %edx,%edx
80100772:	74 28                	je     8010079c <cprintf+0x17c>
80100774:	fa                   	cli    
    for(;;)
80100775:	eb fe                	jmp    80100775 <cprintf+0x155>
80100777:	90                   	nop
    release(&cons.lock);
80100778:	83 ec 0c             	sub    $0xc,%esp
8010077b:	68 20 a5 10 80       	push   $0x8010a520
80100780:	e8 8f 39 00 00       	call   80104114 <release>
80100785:	83 c4 10             	add    $0x10,%esp
}
80100788:	e9 fe fe ff ff       	jmp    8010068b <cprintf+0x6b>
    panic("null fmt");
8010078d:	83 ec 0c             	sub    $0xc,%esp
80100790:	68 9f 68 10 80       	push   $0x8010689f
80100795:	e8 a6 fb ff ff       	call   80100340 <panic>
8010079a:	66 90                	xchg   %ax,%ax
8010079c:	89 f8                	mov    %edi,%eax
8010079e:	e8 15 fc ff ff       	call   801003b8 <consputc.part.0>
801007a3:	e9 ca fe ff ff       	jmp    80100672 <cprintf+0x52>

801007a8 <consoleintr>:
{
801007a8:	55                   	push   %ebp
801007a9:	89 e5                	mov    %esp,%ebp
801007ab:	57                   	push   %edi
801007ac:	56                   	push   %esi
801007ad:	53                   	push   %ebx
801007ae:	83 ec 18             	sub    $0x18,%esp
801007b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801007b4:	68 20 a5 10 80       	push   $0x8010a520
801007b9:	e8 be 38 00 00       	call   8010407c <acquire>
  while((c = getc()) >= 0){
801007be:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801007c1:	31 f6                	xor    %esi,%esi
  while((c = getc()) >= 0){
801007c3:	eb 17                	jmp    801007dc <consoleintr+0x34>
    switch(c){
801007c5:	83 fb 08             	cmp    $0x8,%ebx
801007c8:	0f 84 02 01 00 00    	je     801008d0 <consoleintr+0x128>
801007ce:	83 fb 10             	cmp    $0x10,%ebx
801007d1:	0f 85 1d 01 00 00    	jne    801008f4 <consoleintr+0x14c>
801007d7:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801007dc:	ff d7                	call   *%edi
801007de:	89 c3                	mov    %eax,%ebx
801007e0:	85 c0                	test   %eax,%eax
801007e2:	0f 88 2b 01 00 00    	js     80100913 <consoleintr+0x16b>
    switch(c){
801007e8:	83 fb 15             	cmp    $0x15,%ebx
801007eb:	0f 84 8b 00 00 00    	je     8010087c <consoleintr+0xd4>
801007f1:	7e d2                	jle    801007c5 <consoleintr+0x1d>
801007f3:	83 fb 7f             	cmp    $0x7f,%ebx
801007f6:	0f 84 d4 00 00 00    	je     801008d0 <consoleintr+0x128>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007fc:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100801:	89 c2                	mov    %eax,%edx
80100803:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100809:	83 fa 7f             	cmp    $0x7f,%edx
8010080c:	77 ce                	ja     801007dc <consoleintr+0x34>
        c = (c == '\r') ? '\n' : c;
8010080e:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100814:	8d 48 01             	lea    0x1(%eax),%ecx
80100817:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
8010081a:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100820:	83 fb 0d             	cmp    $0xd,%ebx
80100823:	0f 84 06 01 00 00    	je     8010092f <consoleintr+0x187>
        input.buf[input.e++ % INPUT_BUF] = c;
80100829:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
8010082f:	85 d2                	test   %edx,%edx
80100831:	0f 85 03 01 00 00    	jne    8010093a <consoleintr+0x192>
80100837:	89 d8                	mov    %ebx,%eax
80100839:	e8 7a fb ff ff       	call   801003b8 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010083e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100843:	83 fb 0a             	cmp    $0xa,%ebx
80100846:	74 19                	je     80100861 <consoleintr+0xb9>
80100848:	83 fb 04             	cmp    $0x4,%ebx
8010084b:	74 14                	je     80100861 <consoleintr+0xb9>
8010084d:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100853:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
80100859:	39 c2                	cmp    %eax,%edx
8010085b:	0f 85 7b ff ff ff    	jne    801007dc <consoleintr+0x34>
          input.w = input.e;
80100861:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100866:	83 ec 0c             	sub    $0xc,%esp
80100869:	68 a0 ff 10 80       	push   $0x8010ffa0
8010086e:	e8 55 33 00 00       	call   80103bc8 <wakeup>
80100873:	83 c4 10             	add    $0x10,%esp
80100876:	e9 61 ff ff ff       	jmp    801007dc <consoleintr+0x34>
8010087b:	90                   	nop
      while(input.e != input.w &&
8010087c:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100881:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100887:	0f 84 4f ff ff ff    	je     801007dc <consoleintr+0x34>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010088d:	48                   	dec    %eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100893:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010089a:	0f 84 3c ff ff ff    	je     801007dc <consoleintr+0x34>
        input.e--;
801008a0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008a5:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008ab:	85 d2                	test   %edx,%edx
801008ad:	74 05                	je     801008b4 <consoleintr+0x10c>
801008af:	fa                   	cli    
    for(;;)
801008b0:	eb fe                	jmp    801008b0 <consoleintr+0x108>
801008b2:	66 90                	xchg   %ax,%ax
801008b4:	b8 00 01 00 00       	mov    $0x100,%eax
801008b9:	e8 fa fa ff ff       	call   801003b8 <consputc.part.0>
      while(input.e != input.w &&
801008be:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c3:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008c9:	75 c2                	jne    8010088d <consoleintr+0xe5>
801008cb:	e9 0c ff ff ff       	jmp    801007dc <consoleintr+0x34>
      if(input.e != input.w){
801008d0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008d5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008db:	0f 84 fb fe ff ff    	je     801007dc <consoleintr+0x34>
        input.e--;
801008e1:	48                   	dec    %eax
801008e2:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008e7:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801008ec:	85 c0                	test   %eax,%eax
801008ee:	74 14                	je     80100904 <consoleintr+0x15c>
801008f0:	fa                   	cli    
    for(;;)
801008f1:	eb fe                	jmp    801008f1 <consoleintr+0x149>
801008f3:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008f4:	85 db                	test   %ebx,%ebx
801008f6:	0f 84 e0 fe ff ff    	je     801007dc <consoleintr+0x34>
801008fc:	e9 fb fe ff ff       	jmp    801007fc <consoleintr+0x54>
80100901:	8d 76 00             	lea    0x0(%esi),%esi
80100904:	b8 00 01 00 00       	mov    $0x100,%eax
80100909:	e8 aa fa ff ff       	call   801003b8 <consputc.part.0>
8010090e:	e9 c9 fe ff ff       	jmp    801007dc <consoleintr+0x34>
  release(&cons.lock);
80100913:	83 ec 0c             	sub    $0xc,%esp
80100916:	68 20 a5 10 80       	push   $0x8010a520
8010091b:	e8 f4 37 00 00       	call   80104114 <release>
  if(doprocdump) {
80100920:	83 c4 10             	add    $0x10,%esp
80100923:	85 f6                	test   %esi,%esi
80100925:	75 19                	jne    80100940 <consoleintr+0x198>
}
80100927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010092a:	5b                   	pop    %ebx
8010092b:	5e                   	pop    %esi
8010092c:	5f                   	pop    %edi
8010092d:	5d                   	pop    %ebp
8010092e:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
8010092f:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
80100936:	85 d2                	test   %edx,%edx
80100938:	74 12                	je     8010094c <consoleintr+0x1a4>
8010093a:	fa                   	cli    
    for(;;)
8010093b:	eb fe                	jmp    8010093b <consoleintr+0x193>
8010093d:	8d 76 00             	lea    0x0(%esi),%esi
}
80100940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100943:	5b                   	pop    %ebx
80100944:	5e                   	pop    %esi
80100945:	5f                   	pop    %edi
80100946:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100947:	e9 50 33 00 00       	jmp    80103c9c <procdump>
8010094c:	b8 0a 00 00 00       	mov    $0xa,%eax
80100951:	e8 62 fa ff ff       	call   801003b8 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100956:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095b:	e9 01 ff ff ff       	jmp    80100861 <consoleintr+0xb9>

80100960 <consoleinit>:

void
consoleinit(void)
{
80100960:	55                   	push   %ebp
80100961:	89 e5                	mov    %esp,%ebp
80100963:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100966:	68 a8 68 10 80       	push   $0x801068a8
8010096b:	68 20 a5 10 80       	push   $0x8010a520
80100970:	e8 c7 35 00 00       	call   80103f3c <initlock>

  devsw[CONSOLE].write = consolewrite;
80100975:	c7 05 6c 09 11 80 b4 	movl   $0x801005b4,0x8011096c
8010097c:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097f:	c7 05 68 09 11 80 4c 	movl   $0x8010024c,0x80110968
80100986:	02 10 80 
  cons.locking = 1;
80100989:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100990:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100993:	58                   	pop    %eax
80100994:	5a                   	pop    %edx
80100995:	6a 00                	push   $0x0
80100997:	6a 01                	push   $0x1
80100999:	e8 d2 16 00 00       	call   80102070 <ioapicenable>
}
8010099e:	83 c4 10             	add    $0x10,%esp
801009a1:	c9                   	leave  
801009a2:	c3                   	ret    
801009a3:	90                   	nop

801009a4 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a4:	55                   	push   %ebp
801009a5:	89 e5                	mov    %esp,%ebp
801009a7:	57                   	push   %edi
801009a8:	56                   	push   %esi
801009a9:	53                   	push   %ebx
801009aa:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009b0:	e8 af 29 00 00       	call   80103364 <myproc>
801009b5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801009bb:	e8 7c 1e 00 00       	call   8010283c <begin_op>

  if((ip = namei(path)) == 0){
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	ff 75 08             	pushl  0x8(%ebp)
801009c6:	e8 45 13 00 00       	call   80101d10 <namei>
801009cb:	83 c4 10             	add    $0x10,%esp
801009ce:	85 c0                	test   %eax,%eax
801009d0:	0f 84 da 02 00 00    	je     80100cb0 <exec+0x30c>
801009d6:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d8:	83 ec 0c             	sub    $0xc,%esp
801009db:	50                   	push   %eax
801009dc:	e8 7b 0b 00 00       	call   8010155c <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009e1:	6a 34                	push   $0x34
801009e3:	6a 00                	push   $0x0
801009e5:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009eb:	50                   	push   %eax
801009ec:	53                   	push   %ebx
801009ed:	e8 0e 0e 00 00       	call   80101800 <readi>
801009f2:	83 c4 20             	add    $0x20,%esp
801009f5:	83 f8 34             	cmp    $0x34,%eax
801009f8:	74 1e                	je     80100a18 <exec+0x74>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801009fa:	83 ec 0c             	sub    $0xc,%esp
801009fd:	53                   	push   %ebx
801009fe:	e8 b1 0d 00 00       	call   801017b4 <iunlockput>
    end_op();
80100a03:	e8 9c 1e 00 00       	call   801028a4 <end_op>
80100a08:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a13:	5b                   	pop    %ebx
80100a14:	5e                   	pop    %esi
80100a15:	5f                   	pop    %edi
80100a16:	5d                   	pop    %ebp
80100a17:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a18:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a1f:	45 4c 46 
80100a22:	75 d6                	jne    801009fa <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a24:	e8 a7 5b 00 00       	call   801065d0 <setupkvm>
80100a29:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a2f:	85 c0                	test   %eax,%eax
80100a31:	74 c7                	je     801009fa <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a33:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a39:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	0f 84 86 02 00 00    	je     80100ccf <exec+0x32b>
80100a49:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80100a50:	00 00 00 
80100a53:	e9 84 00 00 00       	jmp    80100adc <exec+0x138>
    if(ph.type != ELF_PROG_LOAD)
80100a58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a5f:	75 61                	jne    80100ac2 <exec+0x11e>
    if(ph.memsz < ph.filesz)
80100a61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a6d:	0f 82 85 00 00 00    	jb     80100af8 <exec+0x154>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a79:	72 7d                	jb     80100af8 <exec+0x154>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a7b:	51                   	push   %ecx
80100a7c:	50                   	push   %eax
80100a7d:	57                   	push   %edi
80100a7e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a84:	e8 93 59 00 00       	call   8010641c <allocuvm>
80100a89:	89 c7                	mov    %eax,%edi
80100a8b:	83 c4 10             	add    $0x10,%esp
80100a8e:	85 c0                	test   %eax,%eax
80100a90:	74 66                	je     80100af8 <exec+0x154>
    if(ph.vaddr % PGSIZE != 0)
80100a92:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a98:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a9d:	75 59                	jne    80100af8 <exec+0x154>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100aa8:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100aae:	53                   	push   %ebx
80100aaf:	50                   	push   %eax
80100ab0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ab6:	e8 a5 58 00 00       	call   80106360 <loaduvm>
80100abb:	83 c4 20             	add    $0x20,%esp
80100abe:	85 c0                	test   %eax,%eax
80100ac0:	78 36                	js     80100af8 <exec+0x154>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ac2:	ff 85 f4 fe ff ff    	incl   -0x10c(%ebp)
80100ac8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ace:	83 c6 20             	add    $0x20,%esi
80100ad1:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ad8:	39 c8                	cmp    %ecx,%eax
80100ada:	7e 34                	jle    80100b10 <exec+0x16c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100adc:	6a 20                	push   $0x20
80100ade:	56                   	push   %esi
80100adf:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ae5:	50                   	push   %eax
80100ae6:	53                   	push   %ebx
80100ae7:	e8 14 0d 00 00       	call   80101800 <readi>
80100aec:	83 c4 10             	add    $0x10,%esp
80100aef:	83 f8 20             	cmp    $0x20,%eax
80100af2:	0f 84 60 ff ff ff    	je     80100a58 <exec+0xb4>
    freevm(pgdir);
80100af8:	83 ec 0c             	sub    $0xc,%esp
80100afb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b01:	e8 5a 5a 00 00       	call   80106560 <freevm>
  if(ip){
80100b06:	83 c4 10             	add    $0x10,%esp
80100b09:	e9 ec fe ff ff       	jmp    801009fa <exec+0x56>
80100b0e:	66 90                	xchg   %ax,%ax
80100b10:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b16:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b1c:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b22:	83 ec 0c             	sub    $0xc,%esp
80100b25:	53                   	push   %ebx
80100b26:	e8 89 0c 00 00       	call   801017b4 <iunlockput>
  end_op();
80100b2b:	e8 74 1d 00 00       	call   801028a4 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b30:	83 c4 0c             	add    $0xc,%esp
80100b33:	56                   	push   %esi
80100b34:	57                   	push   %edi
80100b35:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b3b:	56                   	push   %esi
80100b3c:	e8 db 58 00 00       	call   8010641c <allocuvm>
80100b41:	89 c7                	mov    %eax,%edi
80100b43:	83 c4 10             	add    $0x10,%esp
80100b46:	85 c0                	test   %eax,%eax
80100b48:	0f 84 8a 00 00 00    	je     80100bd8 <exec+0x234>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b4e:	83 ec 08             	sub    $0x8,%esp
80100b51:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b57:	50                   	push   %eax
80100b58:	56                   	push   %esi
80100b59:	e8 02 5b 00 00       	call   80106660 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b61:	8b 00                	mov    (%eax),%eax
80100b63:	83 c4 10             	add    $0x10,%esp
80100b66:	89 fb                	mov    %edi,%ebx
80100b68:	31 f6                	xor    %esi,%esi
80100b6a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100b70:	85 c0                	test   %eax,%eax
80100b72:	0f 84 81 00 00 00    	je     80100bf9 <exec+0x255>
80100b78:	89 bd f4 fe ff ff    	mov    %edi,-0x10c(%ebp)
80100b7e:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100b84:	eb 1f                	jmp    80100ba5 <exec+0x201>
80100b86:	66 90                	xchg   %ax,%ax
    ustack[3+argc] = sp;
80100b88:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100b8e:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b95:	46                   	inc    %esi
80100b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b99:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b9c:	85 c0                	test   %eax,%eax
80100b9e:	74 53                	je     80100bf3 <exec+0x24f>
    if(argc >= MAXARG)
80100ba0:	83 fe 20             	cmp    $0x20,%esi
80100ba3:	74 33                	je     80100bd8 <exec+0x234>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	50                   	push   %eax
80100ba9:	e8 36 37 00 00       	call   801042e4 <strlen>
80100bae:	f7 d0                	not    %eax
80100bb0:	01 c3                	add    %eax,%ebx
80100bb2:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bb5:	5a                   	pop    %edx
80100bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb9:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bbc:	e8 23 37 00 00       	call   801042e4 <strlen>
80100bc1:	40                   	inc    %eax
80100bc2:	50                   	push   %eax
80100bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bc6:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bc9:	53                   	push   %ebx
80100bca:	57                   	push   %edi
80100bcb:	e8 d0 5b 00 00       	call   801067a0 <copyout>
80100bd0:	83 c4 20             	add    $0x20,%esp
80100bd3:	85 c0                	test   %eax,%eax
80100bd5:	79 b1                	jns    80100b88 <exec+0x1e4>
80100bd7:	90                   	nop
    freevm(pgdir);
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be1:	e8 7a 59 00 00       	call   80106560 <freevm>
80100be6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bee:	e9 1d fe ff ff       	jmp    80100a10 <exec+0x6c>
80100bf3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
  ustack[3+argc] = 0;
80100bf9:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c00:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c04:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c0b:	ff ff ff 
  ustack[1] = argc;
80100c0e:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c14:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c1b:	89 d9                	mov    %ebx,%ecx
80100c1d:	29 c1                	sub    %eax,%ecx
80100c1f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c25:	83 c0 0c             	add    $0xc,%eax
80100c28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c2a:	50                   	push   %eax
80100c2b:	52                   	push   %edx
80100c2c:	53                   	push   %ebx
80100c2d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c33:	e8 68 5b 00 00       	call   801067a0 <copyout>
80100c38:	83 c4 10             	add    $0x10,%esp
80100c3b:	85 c0                	test   %eax,%eax
80100c3d:	78 99                	js     80100bd8 <exec+0x234>
  for(last=s=path; *s; s++)
80100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c42:	8a 00                	mov    (%eax),%al
80100c44:	8b 55 08             	mov    0x8(%ebp),%edx
80100c47:	84 c0                	test   %al,%al
80100c49:	74 12                	je     80100c5d <exec+0x2b9>
80100c4b:	89 d1                	mov    %edx,%ecx
80100c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
80100c50:	41                   	inc    %ecx
80100c51:	3c 2f                	cmp    $0x2f,%al
80100c53:	75 02                	jne    80100c57 <exec+0x2b3>
80100c55:	89 ca                	mov    %ecx,%edx
  for(last=s=path; *s; s++)
80100c57:	8a 01                	mov    (%ecx),%al
80100c59:	84 c0                	test   %al,%al
80100c5b:	75 f3                	jne    80100c50 <exec+0x2ac>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c5d:	50                   	push   %eax
80100c5e:	6a 10                	push   $0x10
80100c60:	52                   	push   %edx
80100c61:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c67:	89 f0                	mov    %esi,%eax
80100c69:	83 c0 74             	add    $0x74,%eax
80100c6c:	50                   	push   %eax
80100c6d:	e8 3e 36 00 00       	call   801042b0 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c72:	89 f0                	mov    %esi,%eax
80100c74:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->pgdir = pgdir;
80100c77:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c7d:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100c80:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c82:	89 c7                	mov    %eax,%edi
80100c84:	8b 40 20             	mov    0x20(%eax),%eax
80100c87:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c8d:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c90:	8b 47 20             	mov    0x20(%edi),%eax
80100c93:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100c96:	89 3c 24             	mov    %edi,(%esp)
80100c99:	e8 52 55 00 00       	call   801061f0 <switchuvm>
  freevm(oldpgdir);
80100c9e:	89 34 24             	mov    %esi,(%esp)
80100ca1:	e8 ba 58 00 00       	call   80106560 <freevm>
  return 0;
80100ca6:	83 c4 10             	add    $0x10,%esp
80100ca9:	31 c0                	xor    %eax,%eax
80100cab:	e9 60 fd ff ff       	jmp    80100a10 <exec+0x6c>
    end_op();
80100cb0:	e8 ef 1b 00 00       	call   801028a4 <end_op>
    cprintf("exec: fail\n");
80100cb5:	83 ec 0c             	sub    $0xc,%esp
80100cb8:	68 c1 68 10 80       	push   $0x801068c1
80100cbd:	e8 5e f9 ff ff       	call   80100620 <cprintf>
    return -1;
80100cc2:	83 c4 10             	add    $0x10,%esp
80100cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cca:	e9 41 fd ff ff       	jmp    80100a10 <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ccf:	be 00 20 00 00       	mov    $0x2000,%esi
80100cd4:	e9 49 fe ff ff       	jmp    80100b22 <exec+0x17e>
80100cd9:	66 90                	xchg   %ax,%ax
80100cdb:	90                   	nop

80100cdc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100cdc:	55                   	push   %ebp
80100cdd:	89 e5                	mov    %esp,%ebp
80100cdf:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ce2:	68 cd 68 10 80       	push   $0x801068cd
80100ce7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cec:	e8 4b 32 00 00       	call   80103f3c <initlock>
}
80100cf1:	83 c4 10             	add    $0x10,%esp
80100cf4:	c9                   	leave  
80100cf5:	c3                   	ret    
80100cf6:	66 90                	xchg   %ax,%ax

80100cf8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100cf8:	55                   	push   %ebp
80100cf9:	89 e5                	mov    %esp,%ebp
80100cfb:	83 ec 24             	sub    $0x24,%esp
  struct file *f;

  acquire(&ftable.lock);
80100cfe:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d03:	e8 74 33 00 00       	call   8010407c <acquire>
80100d08:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d0b:	b8 f4 ff 10 80       	mov    $0x8010fff4,%eax
80100d10:	eb 0c                	jmp    80100d1e <filealloc+0x26>
80100d12:	66 90                	xchg   %ax,%ax
80100d14:	83 c0 18             	add    $0x18,%eax
80100d17:	3d 54 09 11 80       	cmp    $0x80110954,%eax
80100d1c:	74 26                	je     80100d44 <filealloc+0x4c>
    if(f->ref == 0){
80100d1e:	8b 50 04             	mov    0x4(%eax),%edx
80100d21:	85 d2                	test   %edx,%edx
80100d23:	75 ef                	jne    80100d14 <filealloc+0x1c>
      f->ref = 1;
80100d25:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
80100d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      release(&ftable.lock);
80100d2f:	83 ec 0c             	sub    $0xc,%esp
80100d32:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d37:	e8 d8 33 00 00       	call   80104114 <release>
      return f;
80100d3c:	83 c4 10             	add    $0x10,%esp
80100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d42:	c9                   	leave  
80100d43:	c3                   	ret    
  release(&ftable.lock);
80100d44:	83 ec 0c             	sub    $0xc,%esp
80100d47:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d4c:	e8 c3 33 00 00       	call   80104114 <release>
  return 0;
80100d51:	83 c4 10             	add    $0x10,%esp
80100d54:	31 c0                	xor    %eax,%eax
}
80100d56:	c9                   	leave  
80100d57:	c3                   	ret    

80100d58 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d58:	55                   	push   %ebp
80100d59:	89 e5                	mov    %esp,%ebp
80100d5b:	53                   	push   %ebx
80100d5c:	83 ec 10             	sub    $0x10,%esp
80100d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d62:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d67:	e8 10 33 00 00       	call   8010407c <acquire>
  if(f->ref < 1)
80100d6c:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6f:	83 c4 10             	add    $0x10,%esp
80100d72:	85 c0                	test   %eax,%eax
80100d74:	7e 18                	jle    80100d8e <filedup+0x36>
    panic("filedup");
  f->ref++;
80100d76:	40                   	inc    %eax
80100d77:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d7a:	83 ec 0c             	sub    $0xc,%esp
80100d7d:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d82:	e8 8d 33 00 00       	call   80104114 <release>
  return f;
}
80100d87:	89 d8                	mov    %ebx,%eax
80100d89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d8c:	c9                   	leave  
80100d8d:	c3                   	ret    
    panic("filedup");
80100d8e:	83 ec 0c             	sub    $0xc,%esp
80100d91:	68 d4 68 10 80       	push   $0x801068d4
80100d96:	e8 a5 f5 ff ff       	call   80100340 <panic>
80100d9b:	90                   	nop

80100d9c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d9c:	55                   	push   %ebp
80100d9d:	89 e5                	mov    %esp,%ebp
80100d9f:	57                   	push   %edi
80100da0:	56                   	push   %esi
80100da1:	53                   	push   %ebx
80100da2:	83 ec 28             	sub    $0x28,%esp
80100da5:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100da8:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dad:	e8 ca 32 00 00       	call   8010407c <acquire>
  if(f->ref < 1)
80100db2:	8b 57 04             	mov    0x4(%edi),%edx
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	85 d2                	test   %edx,%edx
80100dba:	0f 8e 8d 00 00 00    	jle    80100e4d <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100dc0:	4a                   	dec    %edx
80100dc1:	89 57 04             	mov    %edx,0x4(%edi)
80100dc4:	75 3a                	jne    80100e00 <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100dc6:	8b 1f                	mov    (%edi),%ebx
80100dc8:	8a 47 09             	mov    0x9(%edi),%al
80100dcb:	88 45 e7             	mov    %al,-0x19(%ebp)
80100dce:	8b 77 0c             	mov    0xc(%edi),%esi
80100dd1:	8b 47 10             	mov    0x10(%edi),%eax
80100dd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100dd7:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100ddd:	83 ec 0c             	sub    $0xc,%esp
80100de0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de5:	e8 2a 33 00 00       	call   80104114 <release>

  if(ff.type == FD_PIPE)
80100dea:	83 c4 10             	add    $0x10,%esp
80100ded:	83 fb 01             	cmp    $0x1,%ebx
80100df0:	74 42                	je     80100e34 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100df2:	83 fb 02             	cmp    $0x2,%ebx
80100df5:	74 1d                	je     80100e14 <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dfa:	5b                   	pop    %ebx
80100dfb:	5e                   	pop    %esi
80100dfc:	5f                   	pop    %edi
80100dfd:	5d                   	pop    %ebp
80100dfe:	c3                   	ret    
80100dff:	90                   	nop
    release(&ftable.lock);
80100e00:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e0a:	5b                   	pop    %ebx
80100e0b:	5e                   	pop    %esi
80100e0c:	5f                   	pop    %edi
80100e0d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e0e:	e9 01 33 00 00       	jmp    80104114 <release>
80100e13:	90                   	nop
    begin_op();
80100e14:	e8 23 1a 00 00       	call   8010283c <begin_op>
    iput(ff.ip);
80100e19:	83 ec 0c             	sub    $0xc,%esp
80100e1c:	ff 75 e0             	pushl  -0x20(%ebp)
80100e1f:	e8 44 08 00 00       	call   80101668 <iput>
    end_op();
80100e24:	83 c4 10             	add    $0x10,%esp
}
80100e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e2a:	5b                   	pop    %ebx
80100e2b:	5e                   	pop    %esi
80100e2c:	5f                   	pop    %edi
80100e2d:	5d                   	pop    %ebp
    end_op();
80100e2e:	e9 71 1a 00 00       	jmp    801028a4 <end_op>
80100e33:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100e34:	83 ec 08             	sub    $0x8,%esp
80100e37:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e3b:	50                   	push   %eax
80100e3c:	56                   	push   %esi
80100e3d:	e8 ee 20 00 00       	call   80102f30 <pipeclose>
80100e42:	83 c4 10             	add    $0x10,%esp
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp
80100e4c:	c3                   	ret    
    panic("fileclose");
80100e4d:	83 ec 0c             	sub    $0xc,%esp
80100e50:	68 dc 68 10 80       	push   $0x801068dc
80100e55:	e8 e6 f4 ff ff       	call   80100340 <panic>
80100e5a:	66 90                	xchg   %ax,%ax

80100e5c <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e5c:	55                   	push   %ebp
80100e5d:	89 e5                	mov    %esp,%ebp
80100e5f:	53                   	push   %ebx
80100e60:	53                   	push   %ebx
80100e61:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e64:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e67:	75 2b                	jne    80100e94 <filestat+0x38>
    ilock(f->ip);
80100e69:	83 ec 0c             	sub    $0xc,%esp
80100e6c:	ff 73 10             	pushl  0x10(%ebx)
80100e6f:	e8 e8 06 00 00       	call   8010155c <ilock>
    stati(f->ip, st);
80100e74:	58                   	pop    %eax
80100e75:	5a                   	pop    %edx
80100e76:	ff 75 0c             	pushl  0xc(%ebp)
80100e79:	ff 73 10             	pushl  0x10(%ebx)
80100e7c:	e8 53 09 00 00       	call   801017d4 <stati>
    iunlock(f->ip);
80100e81:	59                   	pop    %ecx
80100e82:	ff 73 10             	pushl  0x10(%ebx)
80100e85:	e8 9a 07 00 00       	call   80101624 <iunlock>
    return 0;
80100e8a:	83 c4 10             	add    $0x10,%esp
80100e8d:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e92:	c9                   	leave  
80100e93:	c3                   	ret    
  return -1;
80100e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9c:	c9                   	leave  
80100e9d:	c3                   	ret    
80100e9e:	66 90                	xchg   %ax,%ax

80100ea0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	57                   	push   %edi
80100ea4:	56                   	push   %esi
80100ea5:	53                   	push   %ebx
80100ea6:	83 ec 1c             	sub    $0x1c,%esp
80100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100eac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100eaf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100eb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100eb6:	74 60                	je     80100f18 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100eb8:	8b 03                	mov    (%ebx),%eax
80100eba:	83 f8 01             	cmp    $0x1,%eax
80100ebd:	74 45                	je     80100f04 <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ebf:	83 f8 02             	cmp    $0x2,%eax
80100ec2:	75 5b                	jne    80100f1f <fileread+0x7f>
    ilock(f->ip);
80100ec4:	83 ec 0c             	sub    $0xc,%esp
80100ec7:	ff 73 10             	pushl  0x10(%ebx)
80100eca:	e8 8d 06 00 00       	call   8010155c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100ecf:	57                   	push   %edi
80100ed0:	ff 73 14             	pushl  0x14(%ebx)
80100ed3:	56                   	push   %esi
80100ed4:	ff 73 10             	pushl  0x10(%ebx)
80100ed7:	e8 24 09 00 00       	call   80101800 <readi>
80100edc:	83 c4 20             	add    $0x20,%esp
80100edf:	85 c0                	test   %eax,%eax
80100ee1:	7e 03                	jle    80100ee6 <fileread+0x46>
      f->off += r;
80100ee3:	01 43 14             	add    %eax,0x14(%ebx)
80100ee6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	ff 73 10             	pushl  0x10(%ebx)
80100eef:	e8 30 07 00 00       	call   80101624 <iunlock>
    return r;
80100ef4:	83 c4 10             	add    $0x10,%esp
80100ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100efd:	5b                   	pop    %ebx
80100efe:	5e                   	pop    %esi
80100eff:	5f                   	pop    %edi
80100f00:	5d                   	pop    %ebp
80100f01:	c3                   	ret    
80100f02:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
80100f04:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f07:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f0d:	5b                   	pop    %ebx
80100f0e:	5e                   	pop    %esi
80100f0f:	5f                   	pop    %edi
80100f10:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f11:	e9 a2 21 00 00       	jmp    801030b8 <piperead>
80100f16:	66 90                	xchg   %ax,%ax
    return -1;
80100f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1d:	eb db                	jmp    80100efa <fileread+0x5a>
  panic("fileread");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 e6 68 10 80       	push   $0x801068e6
80100f27:	e8 14 f4 ff ff       	call   80100340 <panic>

80100f2c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f2c:	55                   	push   %ebp
80100f2d:	89 e5                	mov    %esp,%ebp
80100f2f:	57                   	push   %edi
80100f30:	56                   	push   %esi
80100f31:	53                   	push   %ebx
80100f32:	83 ec 1c             	sub    $0x1c,%esp
80100f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f3e:	8b 45 10             	mov    0x10(%ebp),%eax
80100f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100f44:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100f48:	0f 84 ae 00 00 00    	je     80100ffc <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100f4e:	8b 03                	mov    (%ebx),%eax
80100f50:	83 f8 01             	cmp    $0x1,%eax
80100f53:	0f 84 c2 00 00 00    	je     8010101b <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f59:	83 f8 02             	cmp    $0x2,%eax
80100f5c:	0f 85 cb 00 00 00    	jne    8010102d <filewrite+0x101>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100f62:	31 ff                	xor    %edi,%edi
    while(i < n){
80100f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f67:	85 c0                	test   %eax,%eax
80100f69:	7f 2c                	jg     80100f97 <filewrite+0x6b>
80100f6b:	e9 9c 00 00 00       	jmp    8010100c <filewrite+0xe0>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f70:	01 43 14             	add    %eax,0x14(%ebx)
80100f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	ff 73 10             	pushl  0x10(%ebx)
80100f7c:	e8 a3 06 00 00       	call   80101624 <iunlock>
      end_op();
80100f81:	e8 1e 19 00 00       	call   801028a4 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f8c:	39 c6                	cmp    %eax,%esi
80100f8e:	75 5f                	jne    80100fef <filewrite+0xc3>
        panic("short filewrite");
      i += r;
80100f90:	01 f7                	add    %esi,%edi
    while(i < n){
80100f92:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100f95:	7e 75                	jle    8010100c <filewrite+0xe0>
      if(n1 > max)
80100f97:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100f9a:	29 fe                	sub    %edi,%esi
80100f9c:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80100fa2:	7e 05                	jle    80100fa9 <filewrite+0x7d>
80100fa4:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80100fa9:	e8 8e 18 00 00       	call   8010283c <begin_op>
      ilock(f->ip);
80100fae:	83 ec 0c             	sub    $0xc,%esp
80100fb1:	ff 73 10             	pushl  0x10(%ebx)
80100fb4:	e8 a3 05 00 00       	call   8010155c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100fb9:	56                   	push   %esi
80100fba:	ff 73 14             	pushl  0x14(%ebx)
80100fbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fc0:	01 f8                	add    %edi,%eax
80100fc2:	50                   	push   %eax
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 2d 09 00 00       	call   801018f8 <writei>
80100fcb:	83 c4 20             	add    $0x20,%esp
80100fce:	85 c0                	test   %eax,%eax
80100fd0:	7f 9e                	jg     80100f70 <filewrite+0x44>
80100fd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      iunlock(f->ip);
80100fd5:	83 ec 0c             	sub    $0xc,%esp
80100fd8:	ff 73 10             	pushl  0x10(%ebx)
80100fdb:	e8 44 06 00 00       	call   80101624 <iunlock>
      end_op();
80100fe0:	e8 bf 18 00 00       	call   801028a4 <end_op>
      if(r < 0)
80100fe5:	83 c4 10             	add    $0x10,%esp
80100fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100feb:	85 c0                	test   %eax,%eax
80100fed:	75 0d                	jne    80100ffc <filewrite+0xd0>
        panic("short filewrite");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 ef 68 10 80       	push   $0x801068ef
80100ff7:	e8 44 f3 ff ff       	call   80100340 <panic>
    }
    return i == n ? n : -1;
80100ffc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret    
80101009:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
8010100c:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010100f:	75 eb                	jne    80100ffc <filewrite+0xd0>
80101011:	89 f8                	mov    %edi,%eax
}
80101013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101016:	5b                   	pop    %ebx
80101017:	5e                   	pop    %esi
80101018:	5f                   	pop    %edi
80101019:	5d                   	pop    %ebp
8010101a:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010101b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010101e:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101028:	e9 9b 1f 00 00       	jmp    80102fc8 <pipewrite>
  panic("filewrite");
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	68 f5 68 10 80       	push   $0x801068f5
80101035:	e8 06 f3 ff ff       	call   80100340 <panic>
8010103a:	66 90                	xchg   %ax,%ax

8010103c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010103c:	55                   	push   %ebp
8010103d:	89 e5                	mov    %esp,%ebp
8010103f:	56                   	push   %esi
80101040:	53                   	push   %ebx
80101041:	89 c1                	mov    %eax,%ecx
80101043:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101045:	83 ec 08             	sub    $0x8,%esp
80101048:	89 d0                	mov    %edx,%eax
8010104a:	c1 e8 0c             	shr    $0xc,%eax
8010104d:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101053:	50                   	push   %eax
80101054:	51                   	push   %ecx
80101055:	e8 5a f0 ff ff       	call   801000b4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010105a:	89 d9                	mov    %ebx,%ecx
8010105c:	83 e1 07             	and    $0x7,%ecx
8010105f:	ba 01 00 00 00       	mov    $0x1,%edx
80101064:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101066:	c1 fb 03             	sar    $0x3,%ebx
80101069:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010106f:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101074:	83 c4 10             	add    $0x10,%esp
80101077:	85 d1                	test   %edx,%ecx
80101079:	74 25                	je     801010a0 <bfree+0x64>
8010107b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010107d:	f7 d2                	not    %edx
8010107f:	21 ca                	and    %ecx,%edx
80101081:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101085:	83 ec 0c             	sub    $0xc,%esp
80101088:	50                   	push   %eax
80101089:	e8 6a 19 00 00       	call   801029f8 <log_write>
  brelse(bp);
8010108e:	89 34 24             	mov    %esi,(%esp)
80101091:	e8 2a f1 ff ff       	call   801001c0 <brelse>
}
80101096:	83 c4 10             	add    $0x10,%esp
80101099:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010109c:	5b                   	pop    %ebx
8010109d:	5e                   	pop    %esi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret    
    panic("freeing free block");
801010a0:	83 ec 0c             	sub    $0xc,%esp
801010a3:	68 ff 68 10 80       	push   $0x801068ff
801010a8:	e8 93 f2 ff ff       	call   80100340 <panic>
801010ad:	8d 76 00             	lea    0x0(%esi),%esi

801010b0 <balloc>:
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010bc:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
801010c2:	85 c9                	test   %ecx,%ecx
801010c4:	74 7e                	je     80101144 <balloc+0x94>
801010c6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010cd:	83 ec 08             	sub    $0x8,%esp
801010d0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010d3:	89 f0                	mov    %esi,%eax
801010d5:	c1 f8 0c             	sar    $0xc,%eax
801010d8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010de:	50                   	push   %eax
801010df:	ff 75 d8             	pushl  -0x28(%ebp)
801010e2:	e8 cd ef ff ff       	call   801000b4 <bread>
801010e7:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010e9:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010f1:	83 c4 10             	add    $0x10,%esp
801010f4:	31 c0                	xor    %eax,%eax
801010f6:	eb 29                	jmp    80101121 <balloc+0x71>
      m = 1 << (bi % 8);
801010f8:	89 c1                	mov    %eax,%ecx
801010fa:	83 e1 07             	and    $0x7,%ecx
801010fd:	bf 01 00 00 00       	mov    $0x1,%edi
80101102:	d3 e7                	shl    %cl,%edi
80101104:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101107:	89 c1                	mov    %eax,%ecx
80101109:	c1 f9 03             	sar    $0x3,%ecx
8010110c:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101111:	89 fa                	mov    %edi,%edx
80101113:	85 7d e4             	test   %edi,-0x1c(%ebp)
80101116:	74 3c                	je     80101154 <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101118:	40                   	inc    %eax
80101119:	46                   	inc    %esi
8010111a:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010111f:	74 05                	je     80101126 <balloc+0x76>
80101121:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101124:	77 d2                	ja     801010f8 <balloc+0x48>
    brelse(bp);
80101126:	83 ec 0c             	sub    $0xc,%esp
80101129:	53                   	push   %ebx
8010112a:	e8 91 f0 ff ff       	call   801001c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010112f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101136:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
80101142:	77 89                	ja     801010cd <balloc+0x1d>
  panic("balloc: out of blocks");
80101144:	83 ec 0c             	sub    $0xc,%esp
80101147:	68 12 69 10 80       	push   $0x80106912
8010114c:	e8 ef f1 ff ff       	call   80100340 <panic>
80101151:	8d 76 00             	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101154:	0b 55 e4             	or     -0x1c(%ebp),%edx
80101157:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	53                   	push   %ebx
8010115f:	e8 94 18 00 00       	call   801029f8 <log_write>
        brelse(bp);
80101164:	89 1c 24             	mov    %ebx,(%esp)
80101167:	e8 54 f0 ff ff       	call   801001c0 <brelse>
  bp = bread(dev, bno);
8010116c:	58                   	pop    %eax
8010116d:	5a                   	pop    %edx
8010116e:	56                   	push   %esi
8010116f:	ff 75 d8             	pushl  -0x28(%ebp)
80101172:	e8 3d ef ff ff       	call   801000b4 <bread>
80101177:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101179:	83 c4 0c             	add    $0xc,%esp
8010117c:	68 00 02 00 00       	push   $0x200
80101181:	6a 00                	push   $0x0
80101183:	8d 40 5c             	lea    0x5c(%eax),%eax
80101186:	50                   	push   %eax
80101187:	e8 d0 2f 00 00       	call   8010415c <memset>
  log_write(bp);
8010118c:	89 1c 24             	mov    %ebx,(%esp)
8010118f:	e8 64 18 00 00       	call   801029f8 <log_write>
  brelse(bp);
80101194:	89 1c 24             	mov    %ebx,(%esp)
80101197:	e8 24 f0 ff ff       	call   801001c0 <brelse>
}
8010119c:	89 f0                	mov    %esi,%eax
8010119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a1:	5b                   	pop    %ebx
801011a2:	5e                   	pop    %esi
801011a3:	5f                   	pop    %edi
801011a4:	5d                   	pop    %ebp
801011a5:	c3                   	ret    
801011a6:	66 90                	xchg   %ax,%ax

801011a8 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011a8:	55                   	push   %ebp
801011a9:	89 e5                	mov    %esp,%ebp
801011ab:	57                   	push   %edi
801011ac:	56                   	push   %esi
801011ad:	53                   	push   %ebx
801011ae:	83 ec 28             	sub    $0x28,%esp
801011b1:	89 c6                	mov    %eax,%esi
801011b3:	89 d7                	mov    %edx,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011b5:	68 e0 09 11 80       	push   $0x801109e0
801011ba:	e8 bd 2e 00 00       	call   8010407c <acquire>
801011bf:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801011c2:	31 c0                	xor    %eax,%eax
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011c4:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011c9:	eb 13                	jmp    801011de <iget+0x36>
801011cb:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011cc:	39 33                	cmp    %esi,(%ebx)
801011ce:	74 68                	je     80101238 <iget+0x90>
801011d0:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011d6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011dc:	73 22                	jae    80101200 <iget+0x58>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801011e1:	85 c9                	test   %ecx,%ecx
801011e3:	7f e7                	jg     801011cc <iget+0x24>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011e5:	85 c0                	test   %eax,%eax
801011e7:	75 e7                	jne    801011d0 <iget+0x28>
801011e9:	89 da                	mov    %ebx,%edx
801011eb:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011f1:	85 c9                	test   %ecx,%ecx
801011f3:	75 66                	jne    8010125b <iget+0xb3>
801011f5:	89 d0                	mov    %edx,%eax
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011f7:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011fd:	72 df                	jb     801011de <iget+0x36>
801011ff:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101200:	85 c0                	test   %eax,%eax
80101202:	74 6f                	je     80101273 <iget+0xcb>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101204:	89 30                	mov    %esi,(%eax)
  ip->inum = inum;
80101206:	89 78 04             	mov    %edi,0x4(%eax)
  ip->ref = 1;
80101209:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101210:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
80101217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  release(&icache.lock);
8010121a:	83 ec 0c             	sub    $0xc,%esp
8010121d:	68 e0 09 11 80       	push   $0x801109e0
80101222:	e8 ed 2e 00 00       	call   80104114 <release>

  return ip;
80101227:	83 c4 10             	add    $0x10,%esp
8010122a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010122d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5f                   	pop    %edi
80101233:	5d                   	pop    %ebp
80101234:	c3                   	ret    
80101235:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101238:	39 7b 04             	cmp    %edi,0x4(%ebx)
8010123b:	75 93                	jne    801011d0 <iget+0x28>
      ip->ref++;
8010123d:	41                   	inc    %ecx
8010123e:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	68 e0 09 11 80       	push   $0x801109e0
80101249:	e8 c6 2e 00 00       	call   80104114 <release>
      return ip;
8010124e:	83 c4 10             	add    $0x10,%esp
80101251:	89 d8                	mov    %ebx,%eax
}
80101253:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101256:	5b                   	pop    %ebx
80101257:	5e                   	pop    %esi
80101258:	5f                   	pop    %edi
80101259:	5d                   	pop    %ebp
8010125a:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101261:	73 10                	jae    80101273 <iget+0xcb>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101263:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101266:	85 c9                	test   %ecx,%ecx
80101268:	0f 8f 5e ff ff ff    	jg     801011cc <iget+0x24>
8010126e:	e9 76 ff ff ff       	jmp    801011e9 <iget+0x41>
    panic("iget: no inodes");
80101273:	83 ec 0c             	sub    $0xc,%esp
80101276:	68 28 69 10 80       	push   $0x80106928
8010127b:	e8 c0 f0 ff ff       	call   80100340 <panic>

80101280 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 1c             	sub    $0x1c,%esp
80101289:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010128b:	83 fa 0b             	cmp    $0xb,%edx
8010128e:	0f 86 80 00 00 00    	jbe    80101314 <bmap+0x94>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101294:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101297:	83 fb 7f             	cmp    $0x7f,%ebx
8010129a:	0f 87 90 00 00 00    	ja     80101330 <bmap+0xb0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012a6:	8b 16                	mov    (%esi),%edx
801012a8:	85 c0                	test   %eax,%eax
801012aa:	74 54                	je     80101300 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012ac:	83 ec 08             	sub    $0x8,%esp
801012af:	50                   	push   %eax
801012b0:	52                   	push   %edx
801012b1:	e8 fe ed ff ff       	call   801000b4 <bread>
801012b6:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012b8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
801012bc:	8b 03                	mov    (%ebx),%eax
801012be:	83 c4 10             	add    $0x10,%esp
801012c1:	85 c0                	test   %eax,%eax
801012c3:	74 1b                	je     801012e0 <bmap+0x60>
801012c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801012c8:	83 ec 0c             	sub    $0xc,%esp
801012cb:	57                   	push   %edi
801012cc:	e8 ef ee ff ff       	call   801001c0 <brelse>
    return addr;
801012d1:	83 c4 10             	add    $0x10,%esp
801012d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
801012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
801012df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801012e0:	8b 06                	mov    (%esi),%eax
801012e2:	e8 c9 fd ff ff       	call   801010b0 <balloc>
801012e7:	89 03                	mov    %eax,(%ebx)
801012e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
801012ec:	83 ec 0c             	sub    $0xc,%esp
801012ef:	57                   	push   %edi
801012f0:	e8 03 17 00 00       	call   801029f8 <log_write>
801012f5:	83 c4 10             	add    $0x10,%esp
801012f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012fb:	eb c8                	jmp    801012c5 <bmap+0x45>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101300:	89 d0                	mov    %edx,%eax
80101302:	e8 a9 fd ff ff       	call   801010b0 <balloc>
80101307:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010130d:	8b 16                	mov    (%esi),%edx
8010130f:	eb 9b                	jmp    801012ac <bmap+0x2c>
80101311:	8d 76 00             	lea    0x0(%esi),%esi
    if((addr = ip->addrs[bn]) == 0)
80101314:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80101317:	8b 43 5c             	mov    0x5c(%ebx),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	75 b9                	jne    801012d7 <bmap+0x57>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010131e:	8b 06                	mov    (%esi),%eax
80101320:	e8 8b fd ff ff       	call   801010b0 <balloc>
80101325:	89 43 5c             	mov    %eax,0x5c(%ebx)
}
80101328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132b:	5b                   	pop    %ebx
8010132c:	5e                   	pop    %esi
8010132d:	5f                   	pop    %edi
8010132e:	5d                   	pop    %ebp
8010132f:	c3                   	ret    
  panic("bmap: out of range");
80101330:	83 ec 0c             	sub    $0xc,%esp
80101333:	68 38 69 10 80       	push   $0x80106938
80101338:	e8 03 f0 ff ff       	call   80100340 <panic>
8010133d:	8d 76 00             	lea    0x0(%esi),%esi

80101340 <readsb>:
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	56                   	push   %esi
80101344:	53                   	push   %ebx
80101345:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101348:	83 ec 08             	sub    $0x8,%esp
8010134b:	6a 01                	push   $0x1
8010134d:	ff 75 08             	pushl  0x8(%ebp)
80101350:	e8 5f ed ff ff       	call   801000b4 <bread>
80101355:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101357:	83 c4 0c             	add    $0xc,%esp
8010135a:	6a 1c                	push   $0x1c
8010135c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010135f:	50                   	push   %eax
80101360:	56                   	push   %esi
80101361:	e8 7a 2e 00 00       	call   801041e0 <memmove>
  brelse(bp);
80101366:	83 c4 10             	add    $0x10,%esp
80101369:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010136c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010136f:	5b                   	pop    %ebx
80101370:	5e                   	pop    %esi
80101371:	5d                   	pop    %ebp
  brelse(bp);
80101372:	e9 49 ee ff ff       	jmp    801001c0 <brelse>
80101377:	90                   	nop

80101378 <iinit>:
{
80101378:	55                   	push   %ebp
80101379:	89 e5                	mov    %esp,%ebp
8010137b:	53                   	push   %ebx
8010137c:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010137f:	68 4b 69 10 80       	push   $0x8010694b
80101384:	68 e0 09 11 80       	push   $0x801109e0
80101389:	e8 ae 2b 00 00       	call   80103f3c <initlock>
  for(i = 0; i < NINODE; i++) {
8010138e:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	68 52 69 10 80       	push   $0x80106952
801013a0:	53                   	push   %ebx
801013a1:	e8 86 2a 00 00       	call   80103e2c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801013a6:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ac:	83 c4 10             	add    $0x10,%esp
801013af:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801013b5:	75 e1                	jne    80101398 <iinit+0x20>
  readsb(dev, &sb);
801013b7:	83 ec 08             	sub    $0x8,%esp
801013ba:	68 c0 09 11 80       	push   $0x801109c0
801013bf:	ff 75 08             	pushl  0x8(%ebp)
801013c2:	e8 79 ff ff ff       	call   80101340 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801013c7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801013cd:	ff 35 d4 09 11 80    	pushl  0x801109d4
801013d3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801013d9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801013df:	ff 35 c8 09 11 80    	pushl  0x801109c8
801013e5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801013eb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801013f1:	68 b8 69 10 80       	push   $0x801069b8
801013f6:	e8 25 f2 ff ff       	call   80100620 <cprintf>
}
801013fb:	83 c4 30             	add    $0x30,%esp
801013fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101401:	c9                   	leave  
80101402:	c3                   	ret    
80101403:	90                   	nop

80101404 <ialloc>:
{
80101404:	55                   	push   %ebp
80101405:	89 e5                	mov    %esp,%ebp
80101407:	57                   	push   %edi
80101408:	56                   	push   %esi
80101409:	53                   	push   %ebx
8010140a:	83 ec 1c             	sub    $0x1c,%esp
8010140d:	8b 75 08             	mov    0x8(%ebp),%esi
80101410:	8b 45 0c             	mov    0xc(%ebp),%eax
80101413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101416:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
8010141d:	0f 86 84 00 00 00    	jbe    801014a7 <ialloc+0xa3>
80101423:	bf 01 00 00 00       	mov    $0x1,%edi
80101428:	eb 17                	jmp    80101441 <ialloc+0x3d>
8010142a:	66 90                	xchg   %ax,%ax
    brelse(bp);
8010142c:	83 ec 0c             	sub    $0xc,%esp
8010142f:	53                   	push   %ebx
80101430:	e8 8b ed ff ff       	call   801001c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101435:	47                   	inc    %edi
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
8010143f:	73 66                	jae    801014a7 <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
80101441:	83 ec 08             	sub    $0x8,%esp
80101444:	89 f8                	mov    %edi,%eax
80101446:	c1 e8 03             	shr    $0x3,%eax
80101449:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010144f:	50                   	push   %eax
80101450:	56                   	push   %esi
80101451:	e8 5e ec ff ff       	call   801000b4 <bread>
80101456:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101458:	89 f8                	mov    %edi,%eax
8010145a:	83 e0 07             	and    $0x7,%eax
8010145d:	c1 e0 06             	shl    $0x6,%eax
80101460:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101464:	83 c4 10             	add    $0x10,%esp
80101467:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010146b:	75 bf                	jne    8010142c <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
8010146d:	50                   	push   %eax
8010146e:	6a 40                	push   $0x40
80101470:	6a 00                	push   $0x0
80101472:	51                   	push   %ecx
80101473:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101476:	e8 e1 2c 00 00       	call   8010415c <memset>
      dip->type = type;
8010147b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010147e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101481:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101484:	89 1c 24             	mov    %ebx,(%esp)
80101487:	e8 6c 15 00 00       	call   801029f8 <log_write>
      brelse(bp);
8010148c:	89 1c 24             	mov    %ebx,(%esp)
8010148f:	e8 2c ed ff ff       	call   801001c0 <brelse>
      return iget(dev, inum);
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	89 fa                	mov    %edi,%edx
80101499:	89 f0                	mov    %esi,%eax
}
8010149b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149e:	5b                   	pop    %ebx
8010149f:	5e                   	pop    %esi
801014a0:	5f                   	pop    %edi
801014a1:	5d                   	pop    %ebp
      return iget(dev, inum);
801014a2:	e9 01 fd ff ff       	jmp    801011a8 <iget>
  panic("ialloc: no inodes");
801014a7:	83 ec 0c             	sub    $0xc,%esp
801014aa:	68 58 69 10 80       	push   $0x80106958
801014af:	e8 8c ee ff ff       	call   80100340 <panic>

801014b4 <iupdate>:
{
801014b4:	55                   	push   %ebp
801014b5:	89 e5                	mov    %esp,%ebp
801014b7:	56                   	push   %esi
801014b8:	53                   	push   %ebx
801014b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014bc:	83 ec 08             	sub    $0x8,%esp
801014bf:	8b 43 04             	mov    0x4(%ebx),%eax
801014c2:	c1 e8 03             	shr    $0x3,%eax
801014c5:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801014cb:	50                   	push   %eax
801014cc:	ff 33                	pushl  (%ebx)
801014ce:	e8 e1 eb ff ff       	call   801000b4 <bread>
801014d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801014d5:	8b 43 04             	mov    0x4(%ebx),%eax
801014d8:	83 e0 07             	and    $0x7,%eax
801014db:	c1 e0 06             	shl    $0x6,%eax
801014de:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801014e2:	8b 53 50             	mov    0x50(%ebx),%edx
801014e5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801014e8:	66 8b 53 52          	mov    0x52(%ebx),%dx
801014ec:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014f0:	8b 53 54             	mov    0x54(%ebx),%edx
801014f3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014f7:	66 8b 53 56          	mov    0x56(%ebx),%dx
801014fb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014ff:	8b 53 58             	mov    0x58(%ebx),%edx
80101502:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101505:	83 c4 0c             	add    $0xc,%esp
80101508:	6a 34                	push   $0x34
8010150a:	83 c3 5c             	add    $0x5c,%ebx
8010150d:	53                   	push   %ebx
8010150e:	83 c0 0c             	add    $0xc,%eax
80101511:	50                   	push   %eax
80101512:	e8 c9 2c 00 00       	call   801041e0 <memmove>
  log_write(bp);
80101517:	89 34 24             	mov    %esi,(%esp)
8010151a:	e8 d9 14 00 00       	call   801029f8 <log_write>
  brelse(bp);
8010151f:	83 c4 10             	add    $0x10,%esp
80101522:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101525:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101528:	5b                   	pop    %ebx
80101529:	5e                   	pop    %esi
8010152a:	5d                   	pop    %ebp
  brelse(bp);
8010152b:	e9 90 ec ff ff       	jmp    801001c0 <brelse>

80101530 <idup>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	83 ec 10             	sub    $0x10,%esp
80101537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010153a:	68 e0 09 11 80       	push   $0x801109e0
8010153f:	e8 38 2b 00 00       	call   8010407c <acquire>
  ip->ref++;
80101544:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101547:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010154e:	e8 c1 2b 00 00       	call   80104114 <release>
}
80101553:	89 d8                	mov    %ebx,%eax
80101555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101558:	c9                   	leave  
80101559:	c3                   	ret    
8010155a:	66 90                	xchg   %ax,%ax

8010155c <ilock>:
{
8010155c:	55                   	push   %ebp
8010155d:	89 e5                	mov    %esp,%ebp
8010155f:	56                   	push   %esi
80101560:	53                   	push   %ebx
80101561:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101564:	85 db                	test   %ebx,%ebx
80101566:	0f 84 a9 00 00 00    	je     80101615 <ilock+0xb9>
8010156c:	8b 53 08             	mov    0x8(%ebx),%edx
8010156f:	85 d2                	test   %edx,%edx
80101571:	0f 8e 9e 00 00 00    	jle    80101615 <ilock+0xb9>
  acquiresleep(&ip->lock);
80101577:	83 ec 0c             	sub    $0xc,%esp
8010157a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010157d:	50                   	push   %eax
8010157e:	e8 dd 28 00 00       	call   80103e60 <acquiresleep>
  if(ip->valid == 0){
80101583:	83 c4 10             	add    $0x10,%esp
80101586:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101589:	85 c0                	test   %eax,%eax
8010158b:	74 07                	je     80101594 <ilock+0x38>
}
8010158d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101590:	5b                   	pop    %ebx
80101591:	5e                   	pop    %esi
80101592:	5d                   	pop    %ebp
80101593:	c3                   	ret    
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101594:	83 ec 08             	sub    $0x8,%esp
80101597:	8b 43 04             	mov    0x4(%ebx),%eax
8010159a:	c1 e8 03             	shr    $0x3,%eax
8010159d:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015a3:	50                   	push   %eax
801015a4:	ff 33                	pushl  (%ebx)
801015a6:	e8 09 eb ff ff       	call   801000b4 <bread>
801015ab:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ad:	8b 43 04             	mov    0x4(%ebx),%eax
801015b0:	83 e0 07             	and    $0x7,%eax
801015b3:	c1 e0 06             	shl    $0x6,%eax
801015b6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015ba:	8b 10                	mov    (%eax),%edx
801015bc:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015c0:	66 8b 50 02          	mov    0x2(%eax),%dx
801015c4:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015c8:	8b 50 04             	mov    0x4(%eax),%edx
801015cb:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015cf:	66 8b 50 06          	mov    0x6(%eax),%dx
801015d3:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015d7:	8b 50 08             	mov    0x8(%eax),%edx
801015da:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015dd:	83 c4 0c             	add    $0xc,%esp
801015e0:	6a 34                	push   $0x34
801015e2:	83 c0 0c             	add    $0xc,%eax
801015e5:	50                   	push   %eax
801015e6:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015e9:	50                   	push   %eax
801015ea:	e8 f1 2b 00 00       	call   801041e0 <memmove>
    brelse(bp);
801015ef:	89 34 24             	mov    %esi,(%esp)
801015f2:	e8 c9 eb ff ff       	call   801001c0 <brelse>
    ip->valid = 1;
801015f7:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015fe:	83 c4 10             	add    $0x10,%esp
80101601:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101606:	75 85                	jne    8010158d <ilock+0x31>
      panic("ilock: no type");
80101608:	83 ec 0c             	sub    $0xc,%esp
8010160b:	68 70 69 10 80       	push   $0x80106970
80101610:	e8 2b ed ff ff       	call   80100340 <panic>
    panic("ilock");
80101615:	83 ec 0c             	sub    $0xc,%esp
80101618:	68 6a 69 10 80       	push   $0x8010696a
8010161d:	e8 1e ed ff ff       	call   80100340 <panic>
80101622:	66 90                	xchg   %ax,%ax

80101624 <iunlock>:
{
80101624:	55                   	push   %ebp
80101625:	89 e5                	mov    %esp,%ebp
80101627:	56                   	push   %esi
80101628:	53                   	push   %ebx
80101629:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010162c:	85 db                	test   %ebx,%ebx
8010162e:	74 28                	je     80101658 <iunlock+0x34>
80101630:	8d 73 0c             	lea    0xc(%ebx),%esi
80101633:	83 ec 0c             	sub    $0xc,%esp
80101636:	56                   	push   %esi
80101637:	e8 b4 28 00 00       	call   80103ef0 <holdingsleep>
8010163c:	83 c4 10             	add    $0x10,%esp
8010163f:	85 c0                	test   %eax,%eax
80101641:	74 15                	je     80101658 <iunlock+0x34>
80101643:	8b 43 08             	mov    0x8(%ebx),%eax
80101646:	85 c0                	test   %eax,%eax
80101648:	7e 0e                	jle    80101658 <iunlock+0x34>
  releasesleep(&ip->lock);
8010164a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010164d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101650:	5b                   	pop    %ebx
80101651:	5e                   	pop    %esi
80101652:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101653:	e9 5c 28 00 00       	jmp    80103eb4 <releasesleep>
    panic("iunlock");
80101658:	83 ec 0c             	sub    $0xc,%esp
8010165b:	68 7f 69 10 80       	push   $0x8010697f
80101660:	e8 db ec ff ff       	call   80100340 <panic>
80101665:	8d 76 00             	lea    0x0(%esi),%esi

80101668 <iput>:
{
80101668:	55                   	push   %ebp
80101669:	89 e5                	mov    %esp,%ebp
8010166b:	57                   	push   %edi
8010166c:	56                   	push   %esi
8010166d:	53                   	push   %ebx
8010166e:	83 ec 28             	sub    $0x28,%esp
80101671:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101674:	8d 73 0c             	lea    0xc(%ebx),%esi
80101677:	56                   	push   %esi
80101678:	e8 e3 27 00 00       	call   80103e60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010167d:	83 c4 10             	add    $0x10,%esp
80101680:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101683:	85 c0                	test   %eax,%eax
80101685:	74 07                	je     8010168e <iput+0x26>
80101687:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010168c:	74 2e                	je     801016bc <iput+0x54>
  releasesleep(&ip->lock);
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	56                   	push   %esi
80101692:	e8 1d 28 00 00       	call   80103eb4 <releasesleep>
  acquire(&icache.lock);
80101697:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010169e:	e8 d9 29 00 00       	call   8010407c <acquire>
  ip->ref--;
801016a3:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
801016a6:	83 c4 10             	add    $0x10,%esp
801016a9:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b3:	5b                   	pop    %ebx
801016b4:	5e                   	pop    %esi
801016b5:	5f                   	pop    %edi
801016b6:	5d                   	pop    %ebp
  release(&icache.lock);
801016b7:	e9 58 2a 00 00       	jmp    80104114 <release>
    acquire(&icache.lock);
801016bc:	83 ec 0c             	sub    $0xc,%esp
801016bf:	68 e0 09 11 80       	push   $0x801109e0
801016c4:	e8 b3 29 00 00       	call   8010407c <acquire>
    int r = ip->ref;
801016c9:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016cc:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016d3:	e8 3c 2a 00 00       	call   80104114 <release>
    if(r == 1){
801016d8:	83 c4 10             	add    $0x10,%esp
801016db:	4f                   	dec    %edi
801016dc:	75 b0                	jne    8010168e <iput+0x26>
801016de:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801016e1:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801016e7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801016ea:	89 fe                	mov    %edi,%esi
801016ec:	89 c7                	mov    %eax,%edi
801016ee:	eb 07                	jmp    801016f7 <iput+0x8f>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801016f0:	83 c6 04             	add    $0x4,%esi
801016f3:	39 fe                	cmp    %edi,%esi
801016f5:	74 15                	je     8010170c <iput+0xa4>
    if(ip->addrs[i]){
801016f7:	8b 16                	mov    (%esi),%edx
801016f9:	85 d2                	test   %edx,%edx
801016fb:	74 f3                	je     801016f0 <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
801016fd:	8b 03                	mov    (%ebx),%eax
801016ff:	e8 38 f9 ff ff       	call   8010103c <bfree>
      ip->addrs[i] = 0;
80101704:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010170a:	eb e4                	jmp    801016f0 <iput+0x88>
8010170c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
8010170f:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101715:	85 c0                	test   %eax,%eax
80101717:	75 2f                	jne    80101748 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101719:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	53                   	push   %ebx
80101724:	e8 8b fd ff ff       	call   801014b4 <iupdate>
      ip->type = 0;
80101729:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
8010172f:	89 1c 24             	mov    %ebx,(%esp)
80101732:	e8 7d fd ff ff       	call   801014b4 <iupdate>
      ip->valid = 0;
80101737:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010173e:	83 c4 10             	add    $0x10,%esp
80101741:	e9 48 ff ff ff       	jmp    8010168e <iput+0x26>
80101746:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101748:	83 ec 08             	sub    $0x8,%esp
8010174b:	50                   	push   %eax
8010174c:	ff 33                	pushl  (%ebx)
8010174e:	e8 61 e9 ff ff       	call   801000b4 <bread>
80101753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101756:	8d 78 5c             	lea    0x5c(%eax),%edi
80101759:	05 5c 02 00 00       	add    $0x25c,%eax
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101764:	89 fe                	mov    %edi,%esi
80101766:	89 c7                	mov    %eax,%edi
80101768:	eb 09                	jmp    80101773 <iput+0x10b>
8010176a:	66 90                	xchg   %ax,%ax
8010176c:	83 c6 04             	add    $0x4,%esi
8010176f:	39 f7                	cmp    %esi,%edi
80101771:	74 11                	je     80101784 <iput+0x11c>
      if(a[j])
80101773:	8b 16                	mov    (%esi),%edx
80101775:	85 d2                	test   %edx,%edx
80101777:	74 f3                	je     8010176c <iput+0x104>
        bfree(ip->dev, a[j]);
80101779:	8b 03                	mov    (%ebx),%eax
8010177b:	e8 bc f8 ff ff       	call   8010103c <bfree>
80101780:	eb ea                	jmp    8010176c <iput+0x104>
80101782:	66 90                	xchg   %ax,%ax
80101784:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010178d:	e8 2e ea ff ff       	call   801001c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101792:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101798:	8b 03                	mov    (%ebx),%eax
8010179a:	e8 9d f8 ff ff       	call   8010103c <bfree>
    ip->addrs[NDIRECT] = 0;
8010179f:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801017a6:	00 00 00 
801017a9:	83 c4 10             	add    $0x10,%esp
801017ac:	e9 68 ff ff ff       	jmp    80101719 <iput+0xb1>
801017b1:	8d 76 00             	lea    0x0(%esi),%esi

801017b4 <iunlockput>:
{
801017b4:	55                   	push   %ebp
801017b5:	89 e5                	mov    %esp,%ebp
801017b7:	53                   	push   %ebx
801017b8:	83 ec 10             	sub    $0x10,%esp
801017bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017be:	53                   	push   %ebx
801017bf:	e8 60 fe ff ff       	call   80101624 <iunlock>
  iput(ip);
801017c4:	83 c4 10             	add    $0x10,%esp
801017c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801017ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017cd:	c9                   	leave  
  iput(ip);
801017ce:	e9 95 fe ff ff       	jmp    80101668 <iput>
801017d3:	90                   	nop

801017d4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801017d4:	55                   	push   %ebp
801017d5:	89 e5                	mov    %esp,%ebp
801017d7:	8b 55 08             	mov    0x8(%ebp),%edx
801017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017dd:	8b 0a                	mov    (%edx),%ecx
801017df:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017e2:	8b 4a 04             	mov    0x4(%edx),%ecx
801017e5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017e8:	8b 4a 50             	mov    0x50(%edx),%ecx
801017eb:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017ee:	66 8b 4a 56          	mov    0x56(%edx),%cx
801017f2:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017f6:	8b 52 58             	mov    0x58(%edx),%edx
801017f9:	89 50 10             	mov    %edx,0x10(%eax)
}
801017fc:	5d                   	pop    %ebp
801017fd:	c3                   	ret    
801017fe:	66 90                	xchg   %ax,%ax

80101800 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 1c             	sub    $0x1c,%esp
80101809:	8b 7d 08             	mov    0x8(%ebp),%edi
8010180c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010180f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101812:	8b 45 10             	mov    0x10(%ebp),%eax
80101815:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101818:	8b 45 14             	mov    0x14(%ebp),%eax
8010181b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010181e:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
80101823:	0f 84 a3 00 00 00    	je     801018cc <readi+0xcc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101829:	8b 47 58             	mov    0x58(%edi),%eax
8010182c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010182f:	39 c3                	cmp    %eax,%ebx
80101831:	0f 87 b9 00 00 00    	ja     801018f0 <readi+0xf0>
80101837:	89 da                	mov    %ebx,%edx
80101839:	31 c9                	xor    %ecx,%ecx
8010183b:	03 55 e4             	add    -0x1c(%ebp),%edx
8010183e:	0f 92 c1             	setb   %cl
80101841:	89 ce                	mov    %ecx,%esi
80101843:	0f 82 a7 00 00 00    	jb     801018f0 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
80101849:	39 d0                	cmp    %edx,%eax
8010184b:	72 77                	jb     801018c4 <readi+0xc4>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010184d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101850:	85 db                	test   %ebx,%ebx
80101852:	74 65                	je     801018b9 <readi+0xb9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101854:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101857:	89 da                	mov    %ebx,%edx
80101859:	c1 ea 09             	shr    $0x9,%edx
8010185c:	89 f8                	mov    %edi,%eax
8010185e:	e8 1d fa ff ff       	call   80101280 <bmap>
80101863:	83 ec 08             	sub    $0x8,%esp
80101866:	50                   	push   %eax
80101867:	ff 37                	pushl  (%edi)
80101869:	e8 46 e8 ff ff       	call   801000b4 <bread>
8010186e:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101870:	89 d8                	mov    %ebx,%eax
80101872:	25 ff 01 00 00       	and    $0x1ff,%eax
80101877:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010187a:	29 f1                	sub    %esi,%ecx
8010187c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101881:	29 c3                	sub    %eax,%ebx
80101883:	83 c4 10             	add    $0x10,%esp
80101886:	39 cb                	cmp    %ecx,%ebx
80101888:	76 02                	jbe    8010188c <readi+0x8c>
8010188a:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010188c:	51                   	push   %ecx
8010188d:	53                   	push   %ebx
8010188e:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101892:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101895:	50                   	push   %eax
80101896:	ff 75 dc             	pushl  -0x24(%ebp)
80101899:	e8 42 29 00 00       	call   801041e0 <memmove>
    brelse(bp);
8010189e:	8b 55 d8             	mov    -0x28(%ebp),%edx
801018a1:	89 14 24             	mov    %edx,(%esp)
801018a4:	e8 17 e9 ff ff       	call   801001c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018a9:	01 de                	add    %ebx,%esi
801018ab:	01 5d e0             	add    %ebx,-0x20(%ebp)
801018ae:	01 5d dc             	add    %ebx,-0x24(%ebp)
801018b1:	83 c4 10             	add    $0x10,%esp
801018b4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801018b7:	77 9b                	ja     80101854 <readi+0x54>
  }
  return n;
801018b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801018bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018bf:	5b                   	pop    %ebx
801018c0:	5e                   	pop    %esi
801018c1:	5f                   	pop    %edi
801018c2:	5d                   	pop    %ebp
801018c3:	c3                   	ret    
    n = ip->size - off;
801018c4:	29 d8                	sub    %ebx,%eax
801018c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018c9:	eb 82                	jmp    8010184d <readi+0x4d>
801018cb:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018cc:	0f bf 47 52          	movswl 0x52(%edi),%eax
801018d0:	66 83 f8 09          	cmp    $0x9,%ax
801018d4:	77 1a                	ja     801018f0 <readi+0xf0>
801018d6:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801018dd:	85 c0                	test   %eax,%eax
801018df:	74 0f                	je     801018f0 <readi+0xf0>
    return devsw[ip->major].read(ip, dst, n);
801018e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018e4:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801018e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ea:	5b                   	pop    %ebx
801018eb:	5e                   	pop    %esi
801018ec:	5f                   	pop    %edi
801018ed:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801018ee:	ff e0                	jmp    *%eax
      return -1;
801018f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018f5:	eb c5                	jmp    801018bc <readi+0xbc>
801018f7:	90                   	nop

801018f8 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801018f8:	55                   	push   %ebp
801018f9:	89 e5                	mov    %esp,%ebp
801018fb:	57                   	push   %edi
801018fc:	56                   	push   %esi
801018fd:	53                   	push   %ebx
801018fe:	83 ec 1c             	sub    $0x1c,%esp
80101901:	8b 45 08             	mov    0x8(%ebp),%eax
80101904:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101907:	8b 75 0c             	mov    0xc(%ebp),%esi
8010190a:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010190d:	8b 75 10             	mov    0x10(%ebp),%esi
80101910:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101913:	8b 75 14             	mov    0x14(%ebp),%esi
80101916:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101919:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010191e:	0f 84 b0 00 00 00    	je     801019d4 <writei+0xdc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101924:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101927:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010192a:	39 46 58             	cmp    %eax,0x58(%esi)
8010192d:	0f 82 dc 00 00 00    	jb     80101a0f <writei+0x117>
80101933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101936:	31 c9                	xor    %ecx,%ecx
80101938:	01 d0                	add    %edx,%eax
8010193a:	0f 92 c1             	setb   %cl
8010193d:	89 ce                	mov    %ecx,%esi
8010193f:	0f 82 ca 00 00 00    	jb     80101a0f <writei+0x117>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101945:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010194a:	0f 87 bf 00 00 00    	ja     80101a0f <writei+0x117>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101950:	85 d2                	test   %edx,%edx
80101952:	74 75                	je     801019c9 <writei+0xd1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101954:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101957:	89 da                	mov    %ebx,%edx
80101959:	c1 ea 09             	shr    $0x9,%edx
8010195c:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010195f:	89 f8                	mov    %edi,%eax
80101961:	e8 1a f9 ff ff       	call   80101280 <bmap>
80101966:	83 ec 08             	sub    $0x8,%esp
80101969:	50                   	push   %eax
8010196a:	ff 37                	pushl  (%edi)
8010196c:	e8 43 e7 ff ff       	call   801000b4 <bread>
80101971:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101973:	89 d8                	mov    %ebx,%eax
80101975:	25 ff 01 00 00       	and    $0x1ff,%eax
8010197a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010197d:	29 f1                	sub    %esi,%ecx
8010197f:	bb 00 02 00 00       	mov    $0x200,%ebx
80101984:	29 c3                	sub    %eax,%ebx
80101986:	83 c4 10             	add    $0x10,%esp
80101989:	39 cb                	cmp    %ecx,%ebx
8010198b:	76 02                	jbe    8010198f <writei+0x97>
8010198d:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010198f:	52                   	push   %edx
80101990:	53                   	push   %ebx
80101991:	ff 75 dc             	pushl  -0x24(%ebp)
80101994:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101998:	50                   	push   %eax
80101999:	e8 42 28 00 00       	call   801041e0 <memmove>
    log_write(bp);
8010199e:	89 3c 24             	mov    %edi,(%esp)
801019a1:	e8 52 10 00 00       	call   801029f8 <log_write>
    brelse(bp);
801019a6:	89 3c 24             	mov    %edi,(%esp)
801019a9:	e8 12 e8 ff ff       	call   801001c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019ae:	01 de                	add    %ebx,%esi
801019b0:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019b3:	01 5d dc             	add    %ebx,-0x24(%ebp)
801019b6:	83 c4 10             	add    $0x10,%esp
801019b9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801019bc:	77 96                	ja     80101954 <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
801019be:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019c1:	8b 75 e0             	mov    -0x20(%ebp),%esi
801019c4:	3b 70 58             	cmp    0x58(%eax),%esi
801019c7:	77 2f                	ja     801019f8 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801019c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cf:	5b                   	pop    %ebx
801019d0:	5e                   	pop    %esi
801019d1:	5f                   	pop    %edi
801019d2:	5d                   	pop    %ebp
801019d3:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019d4:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019d8:	66 83 f8 09          	cmp    $0x9,%ax
801019dc:	77 31                	ja     80101a0f <writei+0x117>
801019de:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801019e5:	85 c0                	test   %eax,%eax
801019e7:	74 26                	je     80101a0f <writei+0x117>
    return devsw[ip->major].write(ip, src, n);
801019e9:	89 75 10             	mov    %esi,0x10(%ebp)
}
801019ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ef:	5b                   	pop    %ebx
801019f0:	5e                   	pop    %esi
801019f1:	5f                   	pop    %edi
801019f2:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801019f3:	ff e0                	jmp    *%eax
801019f5:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
801019f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801019fe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a01:	83 ec 0c             	sub    $0xc,%esp
80101a04:	50                   	push   %eax
80101a05:	e8 aa fa ff ff       	call   801014b4 <iupdate>
80101a0a:	83 c4 10             	add    $0x10,%esp
80101a0d:	eb ba                	jmp    801019c9 <writei+0xd1>
      return -1;
80101a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a14:	eb b6                	jmp    801019cc <writei+0xd4>
80101a16:	66 90                	xchg   %ax,%ax

80101a18 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101a18:	55                   	push   %ebp
80101a19:	89 e5                	mov    %esp,%ebp
80101a1b:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a1e:	6a 0e                	push   $0xe
80101a20:	ff 75 0c             	pushl  0xc(%ebp)
80101a23:	ff 75 08             	pushl  0x8(%ebp)
80101a26:	e8 05 28 00 00       	call   80104230 <strncmp>
}
80101a2b:	c9                   	leave  
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi

80101a30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101a3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101a41:	75 7d                	jne    80101ac0 <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a43:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101a46:	85 c9                	test   %ecx,%ecx
80101a48:	74 3d                	je     80101a87 <dirlookup+0x57>
80101a4a:	31 ff                	xor    %edi,%edi
80101a4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101a4f:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a50:	6a 10                	push   $0x10
80101a52:	57                   	push   %edi
80101a53:	56                   	push   %esi
80101a54:	53                   	push   %ebx
80101a55:	e8 a6 fd ff ff       	call   80101800 <readi>
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	83 f8 10             	cmp    $0x10,%eax
80101a60:	75 51                	jne    80101ab3 <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101a62:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a67:	74 16                	je     80101a7f <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101a69:	52                   	push   %edx
80101a6a:	6a 0e                	push   $0xe
80101a6c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a6f:	50                   	push   %eax
80101a70:	ff 75 0c             	pushl  0xc(%ebp)
80101a73:	e8 b8 27 00 00       	call   80104230 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 15                	je     80101a94 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a7f:	83 c7 10             	add    $0x10,%edi
80101a82:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101a85:	72 c9                	jb     80101a50 <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101a87:	31 c0                	xor    %eax,%eax
}
80101a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8c:	5b                   	pop    %ebx
80101a8d:	5e                   	pop    %esi
80101a8e:	5f                   	pop    %edi
80101a8f:	5d                   	pop    %ebp
80101a90:	c3                   	ret    
80101a91:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101a94:	8b 45 10             	mov    0x10(%ebp),%eax
80101a97:	85 c0                	test   %eax,%eax
80101a99:	74 05                	je     80101aa0 <dirlookup+0x70>
        *poff = off;
80101a9b:	8b 45 10             	mov    0x10(%ebp),%eax
80101a9e:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101aa0:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101aa4:	8b 03                	mov    (%ebx),%eax
80101aa6:	e8 fd f6 ff ff       	call   801011a8 <iget>
}
80101aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aae:	5b                   	pop    %ebx
80101aaf:	5e                   	pop    %esi
80101ab0:	5f                   	pop    %edi
80101ab1:	5d                   	pop    %ebp
80101ab2:	c3                   	ret    
      panic("dirlookup read");
80101ab3:	83 ec 0c             	sub    $0xc,%esp
80101ab6:	68 99 69 10 80       	push   $0x80106999
80101abb:	e8 80 e8 ff ff       	call   80100340 <panic>
    panic("dirlookup not DIR");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 87 69 10 80       	push   $0x80106987
80101ac8:	e8 73 e8 ff ff       	call   80100340 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	89 c3                	mov    %eax,%ebx
80101adb:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ade:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ae1:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ae4:	0f 84 36 01 00 00    	je     80101c20 <namex+0x150>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101aea:	e8 75 18 00 00       	call   80103364 <myproc>
80101aef:	8b 70 70             	mov    0x70(%eax),%esi
  acquire(&icache.lock);
80101af2:	83 ec 0c             	sub    $0xc,%esp
80101af5:	68 e0 09 11 80       	push   $0x801109e0
80101afa:	e8 7d 25 00 00       	call   8010407c <acquire>
  ip->ref++;
80101aff:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101b02:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101b09:	e8 06 26 00 00       	call   80104114 <release>
80101b0e:	83 c4 10             	add    $0x10,%esp
80101b11:	89 df                	mov    %ebx,%edi
80101b13:	eb 04                	jmp    80101b19 <namex+0x49>
80101b15:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101b18:	47                   	inc    %edi
  while(*path == '/')
80101b19:	8a 07                	mov    (%edi),%al
80101b1b:	3c 2f                	cmp    $0x2f,%al
80101b1d:	74 f9                	je     80101b18 <namex+0x48>
  if(*path == 0)
80101b1f:	84 c0                	test   %al,%al
80101b21:	0f 84 b9 00 00 00    	je     80101be0 <namex+0x110>
  while(*path != '/' && *path != 0)
80101b27:	8a 07                	mov    (%edi),%al
80101b29:	89 fb                	mov    %edi,%ebx
80101b2b:	3c 2f                	cmp    $0x2f,%al
80101b2d:	75 0c                	jne    80101b3b <namex+0x6b>
80101b2f:	e9 e0 00 00 00       	jmp    80101c14 <namex+0x144>
    path++;
80101b34:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80101b35:	8a 03                	mov    (%ebx),%al
80101b37:	3c 2f                	cmp    $0x2f,%al
80101b39:	74 04                	je     80101b3f <namex+0x6f>
80101b3b:	84 c0                	test   %al,%al
80101b3d:	75 f5                	jne    80101b34 <namex+0x64>
  len = path - s;
80101b3f:	89 d8                	mov    %ebx,%eax
80101b41:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101b43:	83 f8 0d             	cmp    $0xd,%eax
80101b46:	7e 74                	jle    80101bbc <namex+0xec>
    memmove(name, s, DIRSIZ);
80101b48:	51                   	push   %ecx
80101b49:	6a 0e                	push   $0xe
80101b4b:	57                   	push   %edi
80101b4c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b4f:	e8 8c 26 00 00       	call   801041e0 <memmove>
80101b54:	83 c4 10             	add    $0x10,%esp
80101b57:	89 df                	mov    %ebx,%edi
  while(*path == '/')
80101b59:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b5c:	75 08                	jne    80101b66 <namex+0x96>
80101b5e:	66 90                	xchg   %ax,%ax
    path++;
80101b60:	47                   	inc    %edi
  while(*path == '/')
80101b61:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101b64:	74 fa                	je     80101b60 <namex+0x90>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	56                   	push   %esi
80101b6a:	e8 ed f9 ff ff       	call   8010155c <ilock>
    if(ip->type != T_DIR){
80101b6f:	83 c4 10             	add    $0x10,%esp
80101b72:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b77:	75 7b                	jne    80101bf4 <namex+0x124>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101b79:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b7c:	85 c0                	test   %eax,%eax
80101b7e:	74 09                	je     80101b89 <namex+0xb9>
80101b80:	80 3f 00             	cmpb   $0x0,(%edi)
80101b83:	0f 84 af 00 00 00    	je     80101c38 <namex+0x168>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101b89:	50                   	push   %eax
80101b8a:	6a 00                	push   $0x0
80101b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b8f:	56                   	push   %esi
80101b90:	e8 9b fe ff ff       	call   80101a30 <dirlookup>
80101b95:	89 c3                	mov    %eax,%ebx
80101b97:	83 c4 10             	add    $0x10,%esp
80101b9a:	85 c0                	test   %eax,%eax
80101b9c:	74 56                	je     80101bf4 <namex+0x124>
  iunlock(ip);
80101b9e:	83 ec 0c             	sub    $0xc,%esp
80101ba1:	56                   	push   %esi
80101ba2:	e8 7d fa ff ff       	call   80101624 <iunlock>
  iput(ip);
80101ba7:	89 34 24             	mov    %esi,(%esp)
80101baa:	e8 b9 fa ff ff       	call   80101668 <iput>
80101baf:	83 c4 10             	add    $0x10,%esp
80101bb2:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101bb4:	e9 60 ff ff ff       	jmp    80101b19 <namex+0x49>
80101bb9:	8d 76 00             	lea    0x0(%esi),%esi
80101bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101bbf:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101bc2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101bc5:	52                   	push   %edx
80101bc6:	50                   	push   %eax
80101bc7:	57                   	push   %edi
80101bc8:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bcb:	e8 10 26 00 00       	call   801041e0 <memmove>
    name[len] = 0;
80101bd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101bd3:	c6 00 00             	movb   $0x0,(%eax)
80101bd6:	83 c4 10             	add    $0x10,%esp
80101bd9:	89 df                	mov    %ebx,%edi
80101bdb:	e9 79 ff ff ff       	jmp    80101b59 <namex+0x89>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101be0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be3:	85 db                	test   %ebx,%ebx
80101be5:	75 69                	jne    80101c50 <namex+0x180>
    iput(ip);
    return 0;
  }
  return ip;
}
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bec:	5b                   	pop    %ebx
80101bed:	5e                   	pop    %esi
80101bee:	5f                   	pop    %edi
80101bef:	5d                   	pop    %ebp
80101bf0:	c3                   	ret    
80101bf1:	8d 76 00             	lea    0x0(%esi),%esi
  iunlock(ip);
80101bf4:	83 ec 0c             	sub    $0xc,%esp
80101bf7:	56                   	push   %esi
80101bf8:	e8 27 fa ff ff       	call   80101624 <iunlock>
  iput(ip);
80101bfd:	89 34 24             	mov    %esi,(%esp)
80101c00:	e8 63 fa ff ff       	call   80101668 <iput>
      return 0;
80101c05:	83 c4 10             	add    $0x10,%esp
80101c08:	31 f6                	xor    %esi,%esi
}
80101c0a:	89 f0                	mov    %esi,%eax
80101c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0f:	5b                   	pop    %ebx
80101c10:	5e                   	pop    %esi
80101c11:	5f                   	pop    %edi
80101c12:	5d                   	pop    %ebp
80101c13:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101c1a:	31 c0                	xor    %eax,%eax
80101c1c:	eb a7                	jmp    80101bc5 <namex+0xf5>
80101c1e:	66 90                	xchg   %ax,%ax
    ip = iget(ROOTDEV, ROOTINO);
80101c20:	ba 01 00 00 00       	mov    $0x1,%edx
80101c25:	b8 01 00 00 00       	mov    $0x1,%eax
80101c2a:	e8 79 f5 ff ff       	call   801011a8 <iget>
80101c2f:	89 c6                	mov    %eax,%esi
80101c31:	89 df                	mov    %ebx,%edi
80101c33:	e9 e1 fe ff ff       	jmp    80101b19 <namex+0x49>
      iunlock(ip);
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	56                   	push   %esi
80101c3c:	e8 e3 f9 ff ff       	call   80101624 <iunlock>
      return ip;
80101c41:	83 c4 10             	add    $0x10,%esp
}
80101c44:	89 f0                	mov    %esi,%eax
80101c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c49:	5b                   	pop    %ebx
80101c4a:	5e                   	pop    %esi
80101c4b:	5f                   	pop    %edi
80101c4c:	5d                   	pop    %ebp
80101c4d:	c3                   	ret    
80101c4e:	66 90                	xchg   %ax,%ax
    iput(ip);
80101c50:	83 ec 0c             	sub    $0xc,%esp
80101c53:	56                   	push   %esi
80101c54:	e8 0f fa ff ff       	call   80101668 <iput>
    return 0;
80101c59:	83 c4 10             	add    $0x10,%esp
80101c5c:	31 f6                	xor    %esi,%esi
80101c5e:	eb 87                	jmp    80101be7 <namex+0x117>

80101c60 <dirlink>:
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 20             	sub    $0x20,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c6c:	6a 00                	push   $0x0
80101c6e:	ff 75 0c             	pushl  0xc(%ebp)
80101c71:	53                   	push   %ebx
80101c72:	e8 b9 fd ff ff       	call   80101a30 <dirlookup>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	85 c0                	test   %eax,%eax
80101c7c:	75 65                	jne    80101ce3 <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101c81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c84:	85 ff                	test   %edi,%edi
80101c86:	74 29                	je     80101cb1 <dirlink+0x51>
80101c88:	31 ff                	xor    %edi,%edi
80101c8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c8d:	eb 09                	jmp    80101c98 <dirlink+0x38>
80101c8f:	90                   	nop
80101c90:	83 c7 10             	add    $0x10,%edi
80101c93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c96:	73 19                	jae    80101cb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c98:	6a 10                	push   $0x10
80101c9a:	57                   	push   %edi
80101c9b:	56                   	push   %esi
80101c9c:	53                   	push   %ebx
80101c9d:	e8 5e fb ff ff       	call   80101800 <readi>
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	83 f8 10             	cmp    $0x10,%eax
80101ca8:	75 4c                	jne    80101cf6 <dirlink+0x96>
    if(de.inum == 0)
80101caa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101caf:	75 df                	jne    80101c90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101cb1:	50                   	push   %eax
80101cb2:	6a 0e                	push   $0xe
80101cb4:	ff 75 0c             	pushl  0xc(%ebp)
80101cb7:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cba:	50                   	push   %eax
80101cbb:	e8 ac 25 00 00       	call   8010426c <strncpy>
  de.inum = inum;
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cc7:	6a 10                	push   $0x10
80101cc9:	57                   	push   %edi
80101cca:	56                   	push   %esi
80101ccb:	53                   	push   %ebx
80101ccc:	e8 27 fc ff ff       	call   801018f8 <writei>
80101cd1:	83 c4 20             	add    $0x20,%esp
80101cd4:	83 f8 10             	cmp    $0x10,%eax
80101cd7:	75 2a                	jne    80101d03 <dirlink+0xa3>
  return 0;
80101cd9:	31 c0                	xor    %eax,%eax
}
80101cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cde:	5b                   	pop    %ebx
80101cdf:	5e                   	pop    %esi
80101ce0:	5f                   	pop    %edi
80101ce1:	5d                   	pop    %ebp
80101ce2:	c3                   	ret    
    iput(ip);
80101ce3:	83 ec 0c             	sub    $0xc,%esp
80101ce6:	50                   	push   %eax
80101ce7:	e8 7c f9 ff ff       	call   80101668 <iput>
    return -1;
80101cec:	83 c4 10             	add    $0x10,%esp
80101cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cf4:	eb e5                	jmp    80101cdb <dirlink+0x7b>
      panic("dirlink read");
80101cf6:	83 ec 0c             	sub    $0xc,%esp
80101cf9:	68 a8 69 10 80       	push   $0x801069a8
80101cfe:	e8 3d e6 ff ff       	call   80100340 <panic>
    panic("dirlink");
80101d03:	83 ec 0c             	sub    $0xc,%esp
80101d06:	68 c6 6f 10 80       	push   $0x80106fc6
80101d0b:	e8 30 e6 ff ff       	call   80100340 <panic>

80101d10 <namei>:

struct inode*
namei(char *path)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101d16:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101d19:	31 d2                	xor    %edx,%edx
80101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1e:	e8 ad fd ff ff       	call   80101ad0 <namex>
}
80101d23:	c9                   	leave  
80101d24:	c3                   	ret    
80101d25:	8d 76 00             	lea    0x0(%esi),%esi

80101d28 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d28:	55                   	push   %ebp
80101d29:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101d2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d2e:	ba 01 00 00 00       	mov    $0x1,%edx
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101d36:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101d37:	e9 94 fd ff ff       	jmp    80101ad0 <namex>

80101d3c <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d3c:	55                   	push   %ebp
80101d3d:	89 e5                	mov    %esp,%ebp
80101d3f:	57                   	push   %edi
80101d40:	56                   	push   %esi
80101d41:	53                   	push   %ebx
80101d42:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101d45:	85 c0                	test   %eax,%eax
80101d47:	0f 84 99 00 00 00    	je     80101de6 <idestart+0xaa>
80101d4d:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d4f:	8b 70 08             	mov    0x8(%eax),%esi
80101d52:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101d58:	77 7f                	ja     80101dd9 <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d5a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101d5f:	90                   	nop
80101d60:	89 ca                	mov    %ecx,%edx
80101d62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d63:	83 e0 c0             	and    $0xffffffc0,%eax
80101d66:	3c 40                	cmp    $0x40,%al
80101d68:	75 f6                	jne    80101d60 <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d71:	89 f8                	mov    %edi,%eax
80101d73:	ee                   	out    %al,(%dx)
80101d74:	b0 01                	mov    $0x1,%al
80101d76:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d7b:	ee                   	out    %al,(%dx)
80101d7c:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101d81:	89 f0                	mov    %esi,%eax
80101d83:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101d84:	89 f0                	mov    %esi,%eax
80101d86:	c1 f8 08             	sar    $0x8,%eax
80101d89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d8e:	ee                   	out    %al,(%dx)
80101d8f:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d94:	89 f8                	mov    %edi,%eax
80101d96:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d97:	8a 43 04             	mov    0x4(%ebx),%al
80101d9a:	c1 e0 04             	shl    $0x4,%eax
80101d9d:	83 e0 10             	and    $0x10,%eax
80101da0:	83 c8 e0             	or     $0xffffffe0,%eax
80101da3:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101da8:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101da9:	f6 03 04             	testb  $0x4,(%ebx)
80101dac:	75 0e                	jne    80101dbc <idestart+0x80>
80101dae:	b0 20                	mov    $0x20,%al
80101db0:	89 ca                	mov    %ecx,%edx
80101db2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret    
80101dbb:	90                   	nop
80101dbc:	b0 30                	mov    $0x30,%al
80101dbe:	89 ca                	mov    %ecx,%edx
80101dc0:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101dc1:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80101dc4:	b9 80 00 00 00       	mov    $0x80,%ecx
80101dc9:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101dce:	fc                   	cld    
80101dcf:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd4:	5b                   	pop    %ebx
80101dd5:	5e                   	pop    %esi
80101dd6:	5f                   	pop    %edi
80101dd7:	5d                   	pop    %ebp
80101dd8:	c3                   	ret    
    panic("incorrect blockno");
80101dd9:	83 ec 0c             	sub    $0xc,%esp
80101ddc:	68 14 6a 10 80       	push   $0x80106a14
80101de1:	e8 5a e5 ff ff       	call   80100340 <panic>
    panic("idestart");
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	68 0b 6a 10 80       	push   $0x80106a0b
80101dee:	e8 4d e5 ff ff       	call   80100340 <panic>
80101df3:	90                   	nop

80101df4 <ideinit>:
{
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101dfa:	68 26 6a 10 80       	push   $0x80106a26
80101dff:	68 80 a5 10 80       	push   $0x8010a580
80101e04:	e8 33 21 00 00       	call   80103f3c <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101e09:	58                   	pop    %eax
80101e0a:	5a                   	pop    %edx
80101e0b:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101e10:	48                   	dec    %eax
80101e11:	50                   	push   %eax
80101e12:	6a 0e                	push   $0xe
80101e14:	e8 57 02 00 00       	call   80102070 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e19:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e1c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e21:	8d 76 00             	lea    0x0(%esi),%esi
80101e24:	ec                   	in     (%dx),%al
80101e25:	83 e0 c0             	and    $0xffffffc0,%eax
80101e28:	3c 40                	cmp    $0x40,%al
80101e2a:	75 f8                	jne    80101e24 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e2c:	b0 f0                	mov    $0xf0,%al
80101e2e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e33:	ee                   	out    %al,(%dx)
80101e34:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e39:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e3e:	eb 03                	jmp    80101e43 <ideinit+0x4f>
  for(i=0; i<1000; i++){
80101e40:	49                   	dec    %ecx
80101e41:	74 0f                	je     80101e52 <ideinit+0x5e>
80101e43:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e44:	84 c0                	test   %al,%al
80101e46:	74 f8                	je     80101e40 <ideinit+0x4c>
      havedisk1 = 1;
80101e48:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101e4f:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e52:	b0 e0                	mov    $0xe0,%al
80101e54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e59:	ee                   	out    %al,(%dx)
}
80101e5a:	c9                   	leave  
80101e5b:	c3                   	ret    

80101e5c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e5c:	55                   	push   %ebp
80101e5d:	89 e5                	mov    %esp,%ebp
80101e5f:	57                   	push   %edi
80101e60:	56                   	push   %esi
80101e61:	53                   	push   %ebx
80101e62:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101e65:	68 80 a5 10 80       	push   $0x8010a580
80101e6a:	e8 0d 22 00 00       	call   8010407c <acquire>

  if((b = idequeue) == 0){
80101e6f:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	85 db                	test   %ebx,%ebx
80101e7a:	74 5b                	je     80101ed7 <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e7c:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7f:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e84:	8b 33                	mov    (%ebx),%esi
80101e86:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101e8c:	75 27                	jne    80101eb5 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e8e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e93:	90                   	nop
80101e94:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e95:	88 c1                	mov    %al,%cl
80101e97:	83 e1 c0             	and    $0xffffffc0,%ecx
80101e9a:	80 f9 40             	cmp    $0x40,%cl
80101e9d:	75 f5                	jne    80101e94 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101e9f:	a8 21                	test   $0x21,%al
80101ea1:	75 12                	jne    80101eb5 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
80101ea3:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101ea6:	b9 80 00 00 00       	mov    $0x80,%ecx
80101eab:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101eb0:	fc                   	cld    
80101eb1:	f3 6d                	rep insl (%dx),%es:(%edi)
80101eb3:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101eb5:	83 e6 fb             	and    $0xfffffffb,%esi
80101eb8:	83 ce 02             	or     $0x2,%esi
80101ebb:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80101ebd:	83 ec 0c             	sub    $0xc,%esp
80101ec0:	53                   	push   %ebx
80101ec1:	e8 02 1d 00 00       	call   80103bc8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101ec6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	85 c0                	test   %eax,%eax
80101ed0:	74 05                	je     80101ed7 <ideintr+0x7b>
    idestart(idequeue);
80101ed2:	e8 65 fe ff ff       	call   80101d3c <idestart>
    release(&idelock);
80101ed7:	83 ec 0c             	sub    $0xc,%esp
80101eda:	68 80 a5 10 80       	push   $0x8010a580
80101edf:	e8 30 22 00 00       	call   80104114 <release>

  release(&idelock);
}
80101ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee7:	5b                   	pop    %ebx
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
80101eeb:	c3                   	ret    

80101eec <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101eec:	55                   	push   %ebp
80101eed:	89 e5                	mov    %esp,%ebp
80101eef:	53                   	push   %ebx
80101ef0:	83 ec 10             	sub    $0x10,%esp
80101ef3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101ef6:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ef9:	50                   	push   %eax
80101efa:	e8 f1 1f 00 00       	call   80103ef0 <holdingsleep>
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	85 c0                	test   %eax,%eax
80101f04:	0f 84 b7 00 00 00    	je     80101fc1 <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f0a:	8b 03                	mov    (%ebx),%eax
80101f0c:	83 e0 06             	and    $0x6,%eax
80101f0f:	83 f8 02             	cmp    $0x2,%eax
80101f12:	0f 84 9c 00 00 00    	je     80101fb4 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f18:	8b 53 04             	mov    0x4(%ebx),%edx
80101f1b:	85 d2                	test   %edx,%edx
80101f1d:	74 09                	je     80101f28 <iderw+0x3c>
80101f1f:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80101f24:	85 c0                	test   %eax,%eax
80101f26:	74 7f                	je     80101fa7 <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	68 80 a5 10 80       	push   $0x8010a580
80101f30:	e8 47 21 00 00       	call   8010407c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f35:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f3c:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101f41:	83 c4 10             	add    $0x10,%esp
80101f44:	85 c0                	test   %eax,%eax
80101f46:	74 58                	je     80101fa0 <iderw+0xb4>
80101f48:	89 c2                	mov    %eax,%edx
80101f4a:	8b 40 58             	mov    0x58(%eax),%eax
80101f4d:	85 c0                	test   %eax,%eax
80101f4f:	75 f7                	jne    80101f48 <iderw+0x5c>
80101f51:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101f54:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f56:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f5c:	74 36                	je     80101f94 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f5e:	8b 03                	mov    (%ebx),%eax
80101f60:	83 e0 06             	and    $0x6,%eax
80101f63:	83 f8 02             	cmp    $0x2,%eax
80101f66:	74 1b                	je     80101f83 <iderw+0x97>
    sleep(b, &idelock);
80101f68:	83 ec 08             	sub    $0x8,%esp
80101f6b:	68 80 a5 10 80       	push   $0x8010a580
80101f70:	53                   	push   %ebx
80101f71:	e8 9e 1a 00 00       	call   80103a14 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f76:	8b 03                	mov    (%ebx),%eax
80101f78:	83 e0 06             	and    $0x6,%eax
80101f7b:	83 c4 10             	add    $0x10,%esp
80101f7e:	83 f8 02             	cmp    $0x2,%eax
80101f81:	75 e5                	jne    80101f68 <iderw+0x7c>
  }


  release(&idelock);
80101f83:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80101f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8d:	c9                   	leave  
  release(&idelock);
80101f8e:	e9 81 21 00 00       	jmp    80104114 <release>
80101f93:	90                   	nop
    idestart(b);
80101f94:	89 d8                	mov    %ebx,%eax
80101f96:	e8 a1 fd ff ff       	call   80101d3c <idestart>
80101f9b:	eb c1                	jmp    80101f5e <iderw+0x72>
80101f9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fa0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101fa5:	eb ad                	jmp    80101f54 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
80101fa7:	83 ec 0c             	sub    $0xc,%esp
80101faa:	68 55 6a 10 80       	push   $0x80106a55
80101faf:	e8 8c e3 ff ff       	call   80100340 <panic>
    panic("iderw: nothing to do");
80101fb4:	83 ec 0c             	sub    $0xc,%esp
80101fb7:	68 40 6a 10 80       	push   $0x80106a40
80101fbc:	e8 7f e3 ff ff       	call   80100340 <panic>
    panic("iderw: buf not locked");
80101fc1:	83 ec 0c             	sub    $0xc,%esp
80101fc4:	68 2a 6a 10 80       	push   $0x80106a2a
80101fc9:	e8 72 e3 ff ff       	call   80100340 <panic>
80101fce:	66 90                	xchg   %ax,%ax

80101fd0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	56                   	push   %esi
80101fd4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fd5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101fdc:	00 c0 fe 
  ioapic->reg = reg;
80101fdf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101fe6:	00 00 00 
  return ioapic->data;
80101fe9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101fef:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ff2:	c1 ee 10             	shr    $0x10,%esi
80101ff5:	89 f0                	mov    %esi,%eax
80101ff7:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
80101ffa:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102000:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102006:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102009:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  id = ioapicread(REG_ID) >> 24;
80102010:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102013:	39 c2                	cmp    %eax,%edx
80102015:	74 16                	je     8010202d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102017:	83 ec 0c             	sub    $0xc,%esp
8010201a:	68 74 6a 10 80       	push   $0x80106a74
8010201f:	e8 fc e5 ff ff       	call   80100620 <cprintf>
80102024:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010202a:	83 c4 10             	add    $0x10,%esp
8010202d:	83 c6 21             	add    $0x21,%esi
{
80102030:	ba 10 00 00 00       	mov    $0x10,%edx
80102035:	b8 20 00 00 00       	mov    $0x20,%eax
8010203a:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010203c:	89 c3                	mov    %eax,%ebx
8010203e:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->reg = reg;
80102044:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102046:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010204c:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
8010204f:	8d 5a 01             	lea    0x1(%edx),%ebx
80102052:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102054:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010205a:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102061:	40                   	inc    %eax
80102062:	83 c2 02             	add    $0x2,%edx
80102065:	39 f0                	cmp    %esi,%eax
80102067:	75 d3                	jne    8010203c <ioapicinit+0x6c>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102069:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010206c:	5b                   	pop    %ebx
8010206d:	5e                   	pop    %esi
8010206e:	5d                   	pop    %ebp
8010206f:	c3                   	ret    

80102070 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102076:	8d 50 20             	lea    0x20(%eax),%edx
80102079:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
8010207d:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102083:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102085:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010208b:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010208e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102091:	c1 e2 18             	shl    $0x18,%edx
80102094:	40                   	inc    %eax
  ioapic->reg = reg;
80102095:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102097:	a1 34 26 11 80       	mov    0x80112634,%eax
8010209c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010209f:	5d                   	pop    %ebp
801020a0:	c3                   	ret    
801020a1:	66 90                	xchg   %ax,%ax
801020a3:	90                   	nop

801020a4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	53                   	push   %ebx
801020a8:	53                   	push   %ebx
801020a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020ac:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801020b2:	75 70                	jne    80102124 <kfree+0x80>
801020b4:	81 fb a8 56 11 80    	cmp    $0x801156a8,%ebx
801020ba:	72 68                	jb     80102124 <kfree+0x80>
801020bc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801020c2:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801020c7:	77 5b                	ja     80102124 <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801020c9:	52                   	push   %edx
801020ca:	68 00 10 00 00       	push   $0x1000
801020cf:	6a 01                	push   $0x1
801020d1:	53                   	push   %ebx
801020d2:	e8 85 20 00 00       	call   8010415c <memset>

  if(kmem.use_lock)
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801020e0:	85 c9                	test   %ecx,%ecx
801020e2:	75 1c                	jne    80102100 <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020e4:	a1 78 26 11 80       	mov    0x80112678,%eax
801020e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801020eb:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801020f1:	a1 74 26 11 80       	mov    0x80112674,%eax
801020f6:	85 c0                	test   %eax,%eax
801020f8:	75 1a                	jne    80102114 <kfree+0x70>
    release(&kmem.lock);
}
801020fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020fd:	c9                   	leave  
801020fe:	c3                   	ret    
801020ff:	90                   	nop
    acquire(&kmem.lock);
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	68 40 26 11 80       	push   $0x80112640
80102108:	e8 6f 1f 00 00       	call   8010407c <acquire>
8010210d:	83 c4 10             	add    $0x10,%esp
80102110:	eb d2                	jmp    801020e4 <kfree+0x40>
80102112:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102114:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010211b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010211e:	c9                   	leave  
    release(&kmem.lock);
8010211f:	e9 f0 1f 00 00       	jmp    80104114 <release>
    panic("kfree");
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	68 a6 6a 10 80       	push   $0x80106aa6
8010212c:	e8 0f e2 ff ff       	call   80100340 <panic>
80102131:	8d 76 00             	lea    0x0(%esi),%esi

80102134 <freerange>:
{
80102134:	55                   	push   %ebp
80102135:	89 e5                	mov    %esp,%ebp
80102137:	56                   	push   %esi
80102138:	53                   	push   %ebx
80102139:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010213c:	8b 45 08             	mov    0x8(%ebp),%eax
8010213f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102145:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010214b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102151:	39 de                	cmp    %ebx,%esi
80102153:	72 1f                	jb     80102174 <freerange+0x40>
80102155:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102161:	50                   	push   %eax
80102162:	e8 3d ff ff ff       	call   801020a4 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102167:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010216d:	83 c4 10             	add    $0x10,%esp
80102170:	39 f3                	cmp    %esi,%ebx
80102172:	76 e4                	jbe    80102158 <freerange+0x24>
}
80102174:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102177:	5b                   	pop    %ebx
80102178:	5e                   	pop    %esi
80102179:	5d                   	pop    %ebp
8010217a:	c3                   	ret    
8010217b:	90                   	nop

8010217c <kinit1>:
{
8010217c:	55                   	push   %ebp
8010217d:	89 e5                	mov    %esp,%ebp
8010217f:	56                   	push   %esi
80102180:	53                   	push   %ebx
80102181:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102184:	83 ec 08             	sub    $0x8,%esp
80102187:	68 ac 6a 10 80       	push   $0x80106aac
8010218c:	68 40 26 11 80       	push   $0x80112640
80102191:	e8 a6 1d 00 00       	call   80103f3c <initlock>
  kmem.use_lock = 0;
80102196:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010219d:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801021a0:	8b 45 08             	mov    0x8(%ebp),%eax
801021a3:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801021a9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	39 de                	cmp    %ebx,%esi
801021ba:	72 1c                	jb     801021d8 <kinit1+0x5c>
    kfree(p);
801021bc:	83 ec 0c             	sub    $0xc,%esp
801021bf:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801021c5:	50                   	push   %eax
801021c6:	e8 d9 fe ff ff       	call   801020a4 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021d1:	83 c4 10             	add    $0x10,%esp
801021d4:	39 de                	cmp    %ebx,%esi
801021d6:	73 e4                	jae    801021bc <kinit1+0x40>
}
801021d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021db:	5b                   	pop    %ebx
801021dc:	5e                   	pop    %esi
801021dd:	5d                   	pop    %ebp
801021de:	c3                   	ret    
801021df:	90                   	nop

801021e0 <kinit2>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	56                   	push   %esi
801021e4:	53                   	push   %ebx
801021e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801021e8:	8b 45 08             	mov    0x8(%ebp),%eax
801021eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801021f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801021f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801021fd:	39 de                	cmp    %ebx,%esi
801021ff:	72 1f                	jb     80102220 <kinit2+0x40>
80102201:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010220d:	50                   	push   %eax
8010220e:	e8 91 fe ff ff       	call   801020a4 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102213:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102219:	83 c4 10             	add    $0x10,%esp
8010221c:	39 de                	cmp    %ebx,%esi
8010221e:	73 e4                	jae    80102204 <kinit2+0x24>
  kmem.use_lock = 1;
80102220:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102227:	00 00 00 
}
8010222a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010222d:	5b                   	pop    %ebx
8010222e:	5e                   	pop    %esi
8010222f:	5d                   	pop    %ebp
80102230:	c3                   	ret    
80102231:	8d 76 00             	lea    0x0(%esi),%esi

80102234 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102234:	a1 74 26 11 80       	mov    0x80112674,%eax
80102239:	85 c0                	test   %eax,%eax
8010223b:	75 17                	jne    80102254 <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010223d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102242:	85 c0                	test   %eax,%eax
80102244:	74 0a                	je     80102250 <kalloc+0x1c>
    kmem.freelist = r->next;
80102246:	8b 10                	mov    (%eax),%edx
80102248:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010224e:	c3                   	ret    
8010224f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102250:	c3                   	ret    
80102251:	8d 76 00             	lea    0x0(%esi),%esi
{
80102254:	55                   	push   %ebp
80102255:	89 e5                	mov    %esp,%ebp
80102257:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010225a:	68 40 26 11 80       	push   $0x80112640
8010225f:	e8 18 1e 00 00       	call   8010407c <acquire>
  r = kmem.freelist;
80102264:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102272:	85 c0                	test   %eax,%eax
80102274:	74 08                	je     8010227e <kalloc+0x4a>
    kmem.freelist = r->next;
80102276:	8b 08                	mov    (%eax),%ecx
80102278:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
8010227e:	85 d2                	test   %edx,%edx
80102280:	74 16                	je     80102298 <kalloc+0x64>
80102282:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	68 40 26 11 80       	push   $0x80112640
8010228d:	e8 82 1e 00 00       	call   80104114 <release>
80102292:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102295:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102298:	c9                   	leave  
80102299:	c3                   	ret    
8010229a:	66 90                	xchg   %ax,%ax

8010229c <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010229c:	ba 64 00 00 00       	mov    $0x64,%edx
801022a1:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801022a2:	a8 01                	test   $0x1,%al
801022a4:	0f 84 ae 00 00 00    	je     80102358 <kbdgetc+0xbc>
{
801022aa:	55                   	push   %ebp
801022ab:	89 e5                	mov    %esp,%ebp
801022ad:	53                   	push   %ebx
801022ae:	ba 60 00 00 00       	mov    $0x60,%edx
801022b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801022b4:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
801022b7:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
801022bd:	3c e0                	cmp    $0xe0,%al
801022bf:	74 5b                	je     8010231c <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801022c1:	89 d1                	mov    %edx,%ecx
801022c3:	83 e1 40             	and    $0x40,%ecx
801022c6:	84 c0                	test   %al,%al
801022c8:	78 62                	js     8010232c <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801022ca:	85 c9                	test   %ecx,%ecx
801022cc:	74 09                	je     801022d7 <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801022ce:	83 c8 80             	or     $0xffffff80,%eax
801022d1:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
801022d4:	83 e2 bf             	and    $0xffffffbf,%edx
  }

  shift |= shiftcode[data];
801022d7:	0f b6 8b e0 6b 10 80 	movzbl -0x7fef9420(%ebx),%ecx
801022de:	09 d1                	or     %edx,%ecx
  shift ^= togglecode[data];
801022e0:	0f b6 83 e0 6a 10 80 	movzbl -0x7fef9520(%ebx),%eax
801022e7:	31 c1                	xor    %eax,%ecx
801022e9:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801022ef:	89 c8                	mov    %ecx,%eax
801022f1:	83 e0 03             	and    $0x3,%eax
801022f4:	8b 04 85 c0 6a 10 80 	mov    -0x7fef9540(,%eax,4),%eax
801022fb:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
801022ff:	83 e1 08             	and    $0x8,%ecx
80102302:	74 13                	je     80102317 <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
80102304:	8d 50 9f             	lea    -0x61(%eax),%edx
80102307:	83 fa 19             	cmp    $0x19,%edx
8010230a:	76 44                	jbe    80102350 <kbdgetc+0xb4>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
8010230c:	8d 50 bf             	lea    -0x41(%eax),%edx
8010230f:	83 fa 19             	cmp    $0x19,%edx
80102312:	77 03                	ja     80102317 <kbdgetc+0x7b>
      c += 'a' - 'A';
80102314:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
80102317:	5b                   	pop    %ebx
80102318:	5d                   	pop    %ebp
80102319:	c3                   	ret    
8010231a:	66 90                	xchg   %ax,%ax
    shift |= E0ESC;
8010231c:	83 ca 40             	or     $0x40,%edx
8010231f:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
    return 0;
80102325:	31 c0                	xor    %eax,%eax
}
80102327:	5b                   	pop    %ebx
80102328:	5d                   	pop    %ebp
80102329:	c3                   	ret    
8010232a:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
8010232c:	85 c9                	test   %ecx,%ecx
8010232e:	75 05                	jne    80102335 <kbdgetc+0x99>
80102330:	89 c3                	mov    %eax,%ebx
80102332:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102335:	8a 8b e0 6b 10 80    	mov    -0x7fef9420(%ebx),%cl
8010233b:	83 c9 40             	or     $0x40,%ecx
8010233e:	0f b6 c9             	movzbl %cl,%ecx
80102341:	f7 d1                	not    %ecx
80102343:	21 d1                	and    %edx,%ecx
80102345:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
8010234b:	31 c0                	xor    %eax,%eax
}
8010234d:	5b                   	pop    %ebx
8010234e:	5d                   	pop    %ebp
8010234f:	c3                   	ret    
      c += 'A' - 'a';
80102350:	83 e8 20             	sub    $0x20,%eax
}
80102353:	5b                   	pop    %ebx
80102354:	5d                   	pop    %ebp
80102355:	c3                   	ret    
80102356:	66 90                	xchg   %ax,%ax
    return -1;
80102358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010235d:	c3                   	ret    
8010235e:	66 90                	xchg   %ax,%ax

80102360 <kbdintr>:

void
kbdintr(void)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102366:	68 9c 22 10 80       	push   $0x8010229c
8010236b:	e8 38 e4 ff ff       	call   801007a8 <consoleintr>
}
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	c9                   	leave  
80102374:	c3                   	ret    
80102375:	66 90                	xchg   %ax,%ax
80102377:	90                   	nop

80102378 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102378:	a1 7c 26 11 80       	mov    0x8011267c,%eax
8010237d:	85 c0                	test   %eax,%eax
8010237f:	0f 84 c3 00 00 00    	je     80102448 <lapicinit+0xd0>
  lapic[index] = value;
80102385:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
8010238c:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010238f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102392:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102399:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010239c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010239f:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801023a6:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801023a9:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023ac:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801023b3:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801023b6:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023b9:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801023c0:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023c6:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801023cd:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023d3:	8b 50 30             	mov    0x30(%eax),%edx
801023d6:	c1 ea 10             	shr    $0x10,%edx
801023d9:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801023df:	75 6b                	jne    8010244c <lapicinit+0xd4>
  lapic[index] = value;
801023e1:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801023e8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023ee:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801023f5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023fb:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102402:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102405:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102408:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010240f:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102412:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102415:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
8010241c:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010241f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102422:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102429:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
8010242c:	8b 50 20             	mov    0x20(%eax),%edx
8010242f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102430:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102436:	80 e6 10             	and    $0x10,%dh
80102439:	75 f5                	jne    80102430 <lapicinit+0xb8>
  lapic[index] = value;
8010243b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102442:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102445:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102448:	c3                   	ret    
80102449:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
8010244c:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102453:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102456:	8b 50 20             	mov    0x20(%eax),%edx
}
80102459:	eb 86                	jmp    801023e1 <lapicinit+0x69>
8010245b:	90                   	nop

8010245c <lapicid>:

int
lapicid(void)
{
  if (!lapic)
8010245c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102461:	85 c0                	test   %eax,%eax
80102463:	74 07                	je     8010246c <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102465:	8b 40 20             	mov    0x20(%eax),%eax
80102468:	c1 e8 18             	shr    $0x18,%eax
8010246b:	c3                   	ret    
    return 0;
8010246c:	31 c0                	xor    %eax,%eax
}
8010246e:	c3                   	ret    
8010246f:	90                   	nop

80102470 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102470:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102475:	85 c0                	test   %eax,%eax
80102477:	74 0d                	je     80102486 <lapiceoi+0x16>
  lapic[index] = value;
80102479:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102480:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102483:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102486:	c3                   	ret    
80102487:	90                   	nop

80102488 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102488:	c3                   	ret    
80102489:	8d 76 00             	lea    0x0(%esi),%esi

8010248c <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010248c:	55                   	push   %ebp
8010248d:	89 e5                	mov    %esp,%ebp
8010248f:	53                   	push   %ebx
80102490:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102496:	b0 0f                	mov    $0xf,%al
80102498:	ba 70 00 00 00       	mov    $0x70,%edx
8010249d:	ee                   	out    %al,(%dx)
8010249e:	b0 0a                	mov    $0xa,%al
801024a0:	ba 71 00 00 00       	mov    $0x71,%edx
801024a5:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801024a6:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024ad:	00 00 
  wrv[1] = addr >> 4;
801024af:	89 c8                	mov    %ecx,%eax
801024b1:	c1 e8 04             	shr    $0x4,%eax
801024b4:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801024ba:	a1 7c 26 11 80       	mov    0x8011267c,%eax

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801024bf:	c1 e3 18             	shl    $0x18,%ebx
801024c2:	89 da                	mov    %ebx,%edx
  lapic[index] = value;
801024c4:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024ca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024cd:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801024d4:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024d7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024da:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801024e1:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024e4:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024e7:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024ed:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801024f0:	c1 e9 0c             	shr    $0xc,%ecx
801024f3:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
801024f6:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801024ff:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102505:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102508:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010250e:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102511:	5b                   	pop    %ebx
80102512:	5d                   	pop    %ebp
80102513:	c3                   	ret    

80102514 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	57                   	push   %edi
80102518:	56                   	push   %esi
80102519:	53                   	push   %ebx
8010251a:	83 ec 4c             	sub    $0x4c,%esp
8010251d:	b0 0b                	mov    $0xb,%al
8010251f:	ba 70 00 00 00       	mov    $0x70,%edx
80102524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102525:	ba 71 00 00 00       	mov    $0x71,%edx
8010252a:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010252b:	83 e0 04             	and    $0x4,%eax
8010252e:	88 45 b2             	mov    %al,-0x4e(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102531:	be 70 00 00 00       	mov    $0x70,%esi
80102536:	66 90                	xchg   %ax,%ax
80102538:	31 c0                	xor    %eax,%eax
8010253a:	89 f2                	mov    %esi,%edx
8010253c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010253d:	bb 71 00 00 00       	mov    $0x71,%ebx
80102542:	89 da                	mov    %ebx,%edx
80102544:	ec                   	in     (%dx),%al
80102545:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102548:	bf 02 00 00 00       	mov    $0x2,%edi
8010254d:	89 f8                	mov    %edi,%eax
8010254f:	89 f2                	mov    %esi,%edx
80102551:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102552:	89 da                	mov    %ebx,%edx
80102554:	ec                   	in     (%dx),%al
80102555:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102558:	b0 04                	mov    $0x4,%al
8010255a:	89 f2                	mov    %esi,%edx
8010255c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010255d:	89 da                	mov    %ebx,%edx
8010255f:	ec                   	in     (%dx),%al
80102560:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102563:	b0 07                	mov    $0x7,%al
80102565:	89 f2                	mov    %esi,%edx
80102567:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102568:	89 da                	mov    %ebx,%edx
8010256a:	ec                   	in     (%dx),%al
8010256b:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010256e:	b0 08                	mov    $0x8,%al
80102570:	89 f2                	mov    %esi,%edx
80102572:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102573:	89 da                	mov    %ebx,%edx
80102575:	ec                   	in     (%dx),%al
80102576:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102579:	b0 09                	mov    $0x9,%al
8010257b:	89 f2                	mov    %esi,%edx
8010257d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010257e:	89 da                	mov    %ebx,%edx
80102580:	ec                   	in     (%dx),%al
80102581:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102584:	b0 0a                	mov    $0xa,%al
80102586:	89 f2                	mov    %esi,%edx
80102588:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102589:	89 da                	mov    %ebx,%edx
8010258b:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010258c:	84 c0                	test   %al,%al
8010258e:	78 a8                	js     80102538 <cmostime+0x24>
  return inb(CMOS_RETURN);
80102590:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102594:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102597:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010259b:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010259e:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801025a2:	89 45 c0             	mov    %eax,-0x40(%ebp)
801025a5:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801025a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801025ac:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
801025b0:	89 45 c8             	mov    %eax,-0x38(%ebp)
801025b3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025b6:	31 c0                	xor    %eax,%eax
801025b8:	89 f2                	mov    %esi,%edx
801025ba:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025bb:	89 da                	mov    %ebx,%edx
801025bd:	ec                   	in     (%dx),%al
801025be:	0f b6 c0             	movzbl %al,%eax
801025c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c4:	89 f8                	mov    %edi,%eax
801025c6:	89 f2                	mov    %esi,%edx
801025c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c9:	89 da                	mov    %ebx,%edx
801025cb:	ec                   	in     (%dx),%al
801025cc:	0f b6 c0             	movzbl %al,%eax
801025cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d2:	b0 04                	mov    $0x4,%al
801025d4:	89 f2                	mov    %esi,%edx
801025d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d7:	89 da                	mov    %ebx,%edx
801025d9:	ec                   	in     (%dx),%al
801025da:	0f b6 c0             	movzbl %al,%eax
801025dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e0:	b0 07                	mov    $0x7,%al
801025e2:	89 f2                	mov    %esi,%edx
801025e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e5:	89 da                	mov    %ebx,%edx
801025e7:	ec                   	in     (%dx),%al
801025e8:	0f b6 c0             	movzbl %al,%eax
801025eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ee:	b0 08                	mov    $0x8,%al
801025f0:	89 f2                	mov    %esi,%edx
801025f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
801025f6:	0f b6 c0             	movzbl %al,%eax
801025f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025fc:	b0 09                	mov    $0x9,%al
801025fe:	89 f2                	mov    %esi,%edx
80102600:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102601:	89 da                	mov    %ebx,%edx
80102603:	ec                   	in     (%dx),%al
80102604:	0f b6 c0             	movzbl %al,%eax
80102607:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010260a:	50                   	push   %eax
8010260b:	6a 18                	push   $0x18
8010260d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102610:	50                   	push   %eax
80102611:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102614:	50                   	push   %eax
80102615:	e8 8e 1b 00 00       	call   801041a8 <memcmp>
8010261a:	83 c4 10             	add    $0x10,%esp
8010261d:	85 c0                	test   %eax,%eax
8010261f:	0f 85 13 ff ff ff    	jne    80102538 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
80102625:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102629:	75 7e                	jne    801026a9 <cmostime+0x195>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010262b:	8b 55 b8             	mov    -0x48(%ebp),%edx
8010262e:	89 d0                	mov    %edx,%eax
80102630:	c1 e8 04             	shr    $0x4,%eax
80102633:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102636:	01 c0                	add    %eax,%eax
80102638:	83 e2 0f             	and    $0xf,%edx
8010263b:	01 d0                	add    %edx,%eax
8010263d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102640:	8b 55 bc             	mov    -0x44(%ebp),%edx
80102643:	89 d0                	mov    %edx,%eax
80102645:	c1 e8 04             	shr    $0x4,%eax
80102648:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010264b:	01 c0                	add    %eax,%eax
8010264d:	83 e2 0f             	and    $0xf,%edx
80102650:	01 d0                	add    %edx,%eax
80102652:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102655:	8b 55 c0             	mov    -0x40(%ebp),%edx
80102658:	89 d0                	mov    %edx,%eax
8010265a:	c1 e8 04             	shr    $0x4,%eax
8010265d:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102660:	01 c0                	add    %eax,%eax
80102662:	83 e2 0f             	and    $0xf,%edx
80102665:	01 d0                	add    %edx,%eax
80102667:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010266a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010266d:	89 d0                	mov    %edx,%eax
8010266f:	c1 e8 04             	shr    $0x4,%eax
80102672:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102675:	01 c0                	add    %eax,%eax
80102677:	83 e2 0f             	and    $0xf,%edx
8010267a:	01 d0                	add    %edx,%eax
8010267c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010267f:	8b 55 c8             	mov    -0x38(%ebp),%edx
80102682:	89 d0                	mov    %edx,%eax
80102684:	c1 e8 04             	shr    $0x4,%eax
80102687:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010268a:	01 c0                	add    %eax,%eax
8010268c:	83 e2 0f             	and    $0xf,%edx
8010268f:	01 d0                	add    %edx,%eax
80102691:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102694:	8b 55 cc             	mov    -0x34(%ebp),%edx
80102697:	89 d0                	mov    %edx,%eax
80102699:	c1 e8 04             	shr    $0x4,%eax
8010269c:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010269f:	01 c0                	add    %eax,%eax
801026a1:	83 e2 0f             	and    $0xf,%edx
801026a4:	01 d0                	add    %edx,%eax
801026a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801026a9:	b9 06 00 00 00       	mov    $0x6,%ecx
801026ae:	8b 7d 08             	mov    0x8(%ebp),%edi
801026b1:	8d 75 b8             	lea    -0x48(%ebp),%esi
801026b4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801026b6:	8b 45 08             	mov    0x8(%ebp),%eax
801026b9:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
801026c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026c3:	5b                   	pop    %ebx
801026c4:	5e                   	pop    %esi
801026c5:	5f                   	pop    %edi
801026c6:	5d                   	pop    %ebp
801026c7:	c3                   	ret    

801026c8 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026c8:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801026ce:	85 c9                	test   %ecx,%ecx
801026d0:	7e 7e                	jle    80102750 <install_trans+0x88>
{
801026d2:	55                   	push   %ebp
801026d3:	89 e5                	mov    %esp,%ebp
801026d5:	57                   	push   %edi
801026d6:	56                   	push   %esi
801026d7:	53                   	push   %ebx
801026d8:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801026db:	31 f6                	xor    %esi,%esi
801026dd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801026e0:	83 ec 08             	sub    $0x8,%esp
801026e3:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801026e8:	01 f0                	add    %esi,%eax
801026ea:	40                   	inc    %eax
801026eb:	50                   	push   %eax
801026ec:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026f2:	e8 bd d9 ff ff       	call   801000b4 <bread>
801026f7:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801026f9:	58                   	pop    %eax
801026fa:	5a                   	pop    %edx
801026fb:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102702:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102708:	e8 a7 d9 ff ff       	call   801000b4 <bread>
8010270d:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010270f:	83 c4 0c             	add    $0xc,%esp
80102712:	68 00 02 00 00       	push   $0x200
80102717:	8d 47 5c             	lea    0x5c(%edi),%eax
8010271a:	50                   	push   %eax
8010271b:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010271e:	50                   	push   %eax
8010271f:	e8 bc 1a 00 00       	call   801041e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102724:	89 1c 24             	mov    %ebx,(%esp)
80102727:	e8 5c da ff ff       	call   80100188 <bwrite>
    brelse(lbuf);
8010272c:	89 3c 24             	mov    %edi,(%esp)
8010272f:	e8 8c da ff ff       	call   801001c0 <brelse>
    brelse(dbuf);
80102734:	89 1c 24             	mov    %ebx,(%esp)
80102737:	e8 84 da ff ff       	call   801001c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010273c:	46                   	inc    %esi
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102746:	7f 98                	jg     801026e0 <install_trans+0x18>
  }
}
80102748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010274b:	5b                   	pop    %ebx
8010274c:	5e                   	pop    %esi
8010274d:	5f                   	pop    %edi
8010274e:	5d                   	pop    %ebp
8010274f:	c3                   	ret    
80102750:	c3                   	ret    
80102751:	8d 76 00             	lea    0x0(%esi),%esi

80102754 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	53                   	push   %ebx
80102758:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010275b:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102761:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102767:	e8 48 d9 ff ff       	call   801000b4 <bread>
8010276c:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010276e:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102773:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	85 c0                	test   %eax,%eax
8010277b:	7e 13                	jle    80102790 <write_head+0x3c>
8010277d:	31 d2                	xor    %edx,%edx
8010277f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102780:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102787:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010278b:	42                   	inc    %edx
8010278c:	39 d0                	cmp    %edx,%eax
8010278e:	75 f0                	jne    80102780 <write_head+0x2c>
  }
  bwrite(buf);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	53                   	push   %ebx
80102794:	e8 ef d9 ff ff       	call   80100188 <bwrite>
  brelse(buf);
80102799:	89 1c 24             	mov    %ebx,(%esp)
8010279c:	e8 1f da ff ff       	call   801001c0 <brelse>
}
801027a1:	83 c4 10             	add    $0x10,%esp
801027a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	8d 76 00             	lea    0x0(%esi),%esi

801027ac <initlog>:
{
801027ac:	55                   	push   %ebp
801027ad:	89 e5                	mov    %esp,%ebp
801027af:	53                   	push   %ebx
801027b0:	83 ec 2c             	sub    $0x2c,%esp
801027b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801027b6:	68 e0 6c 10 80       	push   $0x80106ce0
801027bb:	68 80 26 11 80       	push   $0x80112680
801027c0:	e8 77 17 00 00       	call   80103f3c <initlock>
  readsb(dev, &sb);
801027c5:	58                   	pop    %eax
801027c6:	5a                   	pop    %edx
801027c7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027ca:	50                   	push   %eax
801027cb:	53                   	push   %ebx
801027cc:	e8 6f eb ff ff       	call   80101340 <readsb>
  log.start = sb.logstart;
801027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027d4:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801027dc:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.dev = dev;
801027e2:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
801027e8:	59                   	pop    %ecx
801027e9:	5a                   	pop    %edx
801027ea:	50                   	push   %eax
801027eb:	53                   	push   %ebx
801027ec:	e8 c3 d8 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
801027f1:	8b 48 5c             	mov    0x5c(%eax),%ecx
801027f4:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801027fa:	83 c4 10             	add    $0x10,%esp
801027fd:	85 c9                	test   %ecx,%ecx
801027ff:	7e 13                	jle    80102814 <initlog+0x68>
80102801:	31 d2                	xor    %edx,%edx
80102803:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102804:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102808:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010280f:	42                   	inc    %edx
80102810:	39 d1                	cmp    %edx,%ecx
80102812:	75 f0                	jne    80102804 <initlog+0x58>
  brelse(buf);
80102814:	83 ec 0c             	sub    $0xc,%esp
80102817:	50                   	push   %eax
80102818:	e8 a3 d9 ff ff       	call   801001c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010281d:	e8 a6 fe ff ff       	call   801026c8 <install_trans>
  log.lh.n = 0;
80102822:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102829:	00 00 00 
  write_head(); // clear the log
8010282c:	e8 23 ff ff ff       	call   80102754 <write_head>
}
80102831:	83 c4 10             	add    $0x10,%esp
80102834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102837:	c9                   	leave  
80102838:	c3                   	ret    
80102839:	8d 76 00             	lea    0x0(%esi),%esi

8010283c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
8010283c:	55                   	push   %ebp
8010283d:	89 e5                	mov    %esp,%ebp
8010283f:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102842:	68 80 26 11 80       	push   $0x80112680
80102847:	e8 30 18 00 00       	call   8010407c <acquire>
8010284c:	83 c4 10             	add    $0x10,%esp
8010284f:	eb 18                	jmp    80102869 <begin_op+0x2d>
80102851:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102854:	83 ec 08             	sub    $0x8,%esp
80102857:	68 80 26 11 80       	push   $0x80112680
8010285c:	68 80 26 11 80       	push   $0x80112680
80102861:	e8 ae 11 00 00       	call   80103a14 <sleep>
80102866:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102869:	a1 c0 26 11 80       	mov    0x801126c0,%eax
8010286e:	85 c0                	test   %eax,%eax
80102870:	75 e2                	jne    80102854 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102872:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102877:	8d 50 01             	lea    0x1(%eax),%edx
8010287a:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
8010287e:	01 c0                	add    %eax,%eax
80102880:	03 05 c8 26 11 80    	add    0x801126c8,%eax
80102886:	83 f8 1e             	cmp    $0x1e,%eax
80102889:	7f c9                	jg     80102854 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
8010288b:	89 15 bc 26 11 80    	mov    %edx,0x801126bc
      release(&log.lock);
80102891:	83 ec 0c             	sub    $0xc,%esp
80102894:	68 80 26 11 80       	push   $0x80112680
80102899:	e8 76 18 00 00       	call   80104114 <release>
      break;
    }
  }
}
8010289e:	83 c4 10             	add    $0x10,%esp
801028a1:	c9                   	leave  
801028a2:	c3                   	ret    
801028a3:	90                   	nop

801028a4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	57                   	push   %edi
801028a8:	56                   	push   %esi
801028a9:	53                   	push   %ebx
801028aa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801028ad:	68 80 26 11 80       	push   $0x80112680
801028b2:	e8 c5 17 00 00       	call   8010407c <acquire>
  log.outstanding -= 1;
801028b7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801028bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
801028bf:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
801028c5:	83 c4 10             	add    $0x10,%esp
801028c8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
801028ce:	85 f6                	test   %esi,%esi
801028d0:	0f 85 12 01 00 00    	jne    801029e8 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
801028d6:	85 db                	test   %ebx,%ebx
801028d8:	0f 85 e6 00 00 00    	jne    801029c4 <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
801028de:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
801028e5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 80 26 11 80       	push   $0x80112680
801028f0:	e8 1f 18 00 00       	call   80104114 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801028f5:	83 c4 10             	add    $0x10,%esp
801028f8:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801028fe:	85 c9                	test   %ecx,%ecx
80102900:	7f 3a                	jg     8010293c <end_op+0x98>
    acquire(&log.lock);
80102902:	83 ec 0c             	sub    $0xc,%esp
80102905:	68 80 26 11 80       	push   $0x80112680
8010290a:	e8 6d 17 00 00       	call   8010407c <acquire>
    log.committing = 0;
8010290f:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102916:	00 00 00 
    wakeup(&log);
80102919:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102920:	e8 a3 12 00 00       	call   80103bc8 <wakeup>
    release(&log.lock);
80102925:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010292c:	e8 e3 17 00 00       	call   80104114 <release>
80102931:	83 c4 10             	add    $0x10,%esp
}
80102934:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102937:	5b                   	pop    %ebx
80102938:	5e                   	pop    %esi
80102939:	5f                   	pop    %edi
8010293a:	5d                   	pop    %ebp
8010293b:	c3                   	ret    
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010293c:	83 ec 08             	sub    $0x8,%esp
8010293f:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102944:	01 d8                	add    %ebx,%eax
80102946:	40                   	inc    %eax
80102947:	50                   	push   %eax
80102948:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010294e:	e8 61 d7 ff ff       	call   801000b4 <bread>
80102953:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102955:	58                   	pop    %eax
80102956:	5a                   	pop    %edx
80102957:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
8010295e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102964:	e8 4b d7 ff ff       	call   801000b4 <bread>
80102969:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010296b:	83 c4 0c             	add    $0xc,%esp
8010296e:	68 00 02 00 00       	push   $0x200
80102973:	8d 40 5c             	lea    0x5c(%eax),%eax
80102976:	50                   	push   %eax
80102977:	8d 46 5c             	lea    0x5c(%esi),%eax
8010297a:	50                   	push   %eax
8010297b:	e8 60 18 00 00       	call   801041e0 <memmove>
    bwrite(to);  // write the log
80102980:	89 34 24             	mov    %esi,(%esp)
80102983:	e8 00 d8 ff ff       	call   80100188 <bwrite>
    brelse(from);
80102988:	89 3c 24             	mov    %edi,(%esp)
8010298b:	e8 30 d8 ff ff       	call   801001c0 <brelse>
    brelse(to);
80102990:	89 34 24             	mov    %esi,(%esp)
80102993:	e8 28 d8 ff ff       	call   801001c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102998:	43                   	inc    %ebx
80102999:	83 c4 10             	add    $0x10,%esp
8010299c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
801029a2:	7c 98                	jl     8010293c <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801029a4:	e8 ab fd ff ff       	call   80102754 <write_head>
    install_trans(); // Now install writes to home locations
801029a9:	e8 1a fd ff ff       	call   801026c8 <install_trans>
    log.lh.n = 0;
801029ae:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801029b5:	00 00 00 
    write_head();    // Erase the transaction from the log
801029b8:	e8 97 fd ff ff       	call   80102754 <write_head>
801029bd:	e9 40 ff ff ff       	jmp    80102902 <end_op+0x5e>
801029c2:	66 90                	xchg   %ax,%ax
    wakeup(&log);
801029c4:	83 ec 0c             	sub    $0xc,%esp
801029c7:	68 80 26 11 80       	push   $0x80112680
801029cc:	e8 f7 11 00 00       	call   80103bc8 <wakeup>
  release(&log.lock);
801029d1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801029d8:	e8 37 17 00 00       	call   80104114 <release>
801029dd:	83 c4 10             	add    $0x10,%esp
}
801029e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029e3:	5b                   	pop    %ebx
801029e4:	5e                   	pop    %esi
801029e5:	5f                   	pop    %edi
801029e6:	5d                   	pop    %ebp
801029e7:	c3                   	ret    
    panic("log.committing");
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 e4 6c 10 80       	push   $0x80106ce4
801029f0:	e8 4b d9 ff ff       	call   80100340 <panic>
801029f5:	8d 76 00             	lea    0x0(%esi),%esi

801029f8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801029f8:	55                   	push   %ebp
801029f9:	89 e5                	mov    %esp,%ebp
801029fb:	53                   	push   %ebx
801029fc:	52                   	push   %edx
801029fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a00:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102a06:	83 fa 1d             	cmp    $0x1d,%edx
80102a09:	7f 79                	jg     80102a84 <log_write+0x8c>
80102a0b:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102a10:	48                   	dec    %eax
80102a11:	39 c2                	cmp    %eax,%edx
80102a13:	7d 6f                	jge    80102a84 <log_write+0x8c>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a15:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102a1a:	85 c0                	test   %eax,%eax
80102a1c:	7e 73                	jle    80102a91 <log_write+0x99>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a1e:	83 ec 0c             	sub    $0xc,%esp
80102a21:	68 80 26 11 80       	push   $0x80112680
80102a26:	e8 51 16 00 00       	call   8010407c <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	85 d2                	test   %edx,%edx
80102a36:	7e 40                	jle    80102a78 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a38:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a3b:	31 c0                	xor    %eax,%eax
80102a3d:	eb 06                	jmp    80102a45 <log_write+0x4d>
80102a3f:	90                   	nop
80102a40:	40                   	inc    %eax
80102a41:	39 c2                	cmp    %eax,%edx
80102a43:	74 23                	je     80102a68 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a45:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102a4c:	75 f2                	jne    80102a40 <log_write+0x48>
      break;
  }
  log.lh.block[i] = b->blockno;
80102a4e:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a55:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a58:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a62:	c9                   	leave  
  release(&log.lock);
80102a63:	e9 ac 16 00 00       	jmp    80104114 <release>
  log.lh.block[i] = b->blockno;
80102a68:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102a6f:	42                   	inc    %edx
80102a70:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102a76:	eb dd                	jmp    80102a55 <log_write+0x5d>
  log.lh.block[i] = b->blockno;
80102a78:	8b 43 08             	mov    0x8(%ebx),%eax
80102a7b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102a80:	75 d3                	jne    80102a55 <log_write+0x5d>
80102a82:	eb eb                	jmp    80102a6f <log_write+0x77>
    panic("too big a transaction");
80102a84:	83 ec 0c             	sub    $0xc,%esp
80102a87:	68 f3 6c 10 80       	push   $0x80106cf3
80102a8c:	e8 af d8 ff ff       	call   80100340 <panic>
    panic("log_write outside of trans");
80102a91:	83 ec 0c             	sub    $0xc,%esp
80102a94:	68 09 6d 10 80       	push   $0x80106d09
80102a99:	e8 a2 d8 ff ff       	call   80100340 <panic>
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102aa5:	e8 86 08 00 00       	call   80103330 <cpuid>
80102aaa:	89 c3                	mov    %eax,%ebx
80102aac:	e8 7f 08 00 00       	call   80103330 <cpuid>
80102ab1:	52                   	push   %edx
80102ab2:	53                   	push   %ebx
80102ab3:	50                   	push   %eax
80102ab4:	68 24 6d 10 80       	push   $0x80106d24
80102ab9:	e8 62 db ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102abe:	e8 ed 26 00 00       	call   801051b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ac3:	e8 04 08 00 00       	call   801032cc <mycpu>
80102ac8:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102aca:	b8 01 00 00 00       	mov    $0x1,%eax
80102acf:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ad6:	e8 b5 0b 00 00       	call   80103690 <scheduler>
80102adb:	90                   	nop

80102adc <mpenter>:
{
80102adc:	55                   	push   %ebp
80102add:	89 e5                	mov    %esp,%ebp
80102adf:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ae2:	e8 f9 36 00 00       	call   801061e0 <switchkvm>
  seginit();
80102ae7:	e8 70 36 00 00       	call   8010615c <seginit>
  lapicinit();
80102aec:	e8 87 f8 ff ff       	call   80102378 <lapicinit>
  mpmain();
80102af1:	e8 aa ff ff ff       	call   80102aa0 <mpmain>
80102af6:	66 90                	xchg   %ax,%ax

80102af8 <main>:
{
80102af8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102afc:	83 e4 f0             	and    $0xfffffff0,%esp
80102aff:	ff 71 fc             	pushl  -0x4(%ecx)
80102b02:	55                   	push   %ebp
80102b03:	89 e5                	mov    %esp,%ebp
80102b05:	53                   	push   %ebx
80102b06:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b07:	83 ec 08             	sub    $0x8,%esp
80102b0a:	68 00 00 40 80       	push   $0x80400000
80102b0f:	68 a8 56 11 80       	push   $0x801156a8
80102b14:	e8 63 f6 ff ff       	call   8010217c <kinit1>
  kvmalloc();      // kernel page table
80102b19:	e8 26 3b 00 00       	call   80106644 <kvmalloc>
  mpinit();        // detect other processors
80102b1e:	e8 61 01 00 00       	call   80102c84 <mpinit>
  lapicinit();     // interrupt controller
80102b23:	e8 50 f8 ff ff       	call   80102378 <lapicinit>
  seginit();       // segment descriptors
80102b28:	e8 2f 36 00 00       	call   8010615c <seginit>
  picinit();       // disable pic
80102b2d:	e8 f2 02 00 00       	call   80102e24 <picinit>
  ioapicinit();    // another interrupt controller
80102b32:	e8 99 f4 ff ff       	call   80101fd0 <ioapicinit>
  consoleinit();   // console hardware
80102b37:	e8 24 de ff ff       	call   80100960 <consoleinit>
  uartinit();      // serial port
80102b3c:	e8 3b 29 00 00       	call   8010547c <uartinit>
  pinit();         // process table
80102b41:	e8 6a 07 00 00       	call   801032b0 <pinit>
  tvinit();        // trap vectors
80102b46:	e8 f9 25 00 00       	call   80105144 <tvinit>
  binit();         // buffer cache
80102b4b:	e8 e4 d4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102b50:	e8 87 e1 ff ff       	call   80100cdc <fileinit>
  ideinit();       // disk 
80102b55:	e8 9a f2 ff ff       	call   80101df4 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102b5a:	83 c4 0c             	add    $0xc,%esp
80102b5d:	68 8a 00 00 00       	push   $0x8a
80102b62:	68 8c a4 10 80       	push   $0x8010a48c
80102b67:	68 00 70 00 80       	push   $0x80007000
80102b6c:	e8 6f 16 00 00       	call   801041e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b71:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102b77:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102b7a:	01 c0                	add    %eax,%eax
80102b7c:	01 d0                	add    %edx,%eax
80102b7e:	c1 e0 04             	shl    $0x4,%eax
80102b81:	05 80 27 11 80       	add    $0x80112780,%eax
80102b86:	83 c4 10             	add    $0x10,%esp
80102b89:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102b8e:	76 74                	jbe    80102c04 <main+0x10c>
80102b90:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102b95:	eb 20                	jmp    80102bb7 <main+0xbf>
80102b97:	90                   	nop
80102b98:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b9e:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102ba4:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102ba7:	01 c0                	add    %eax,%eax
80102ba9:	01 d0                	add    %edx,%eax
80102bab:	c1 e0 04             	shl    $0x4,%eax
80102bae:	05 80 27 11 80       	add    $0x80112780,%eax
80102bb3:	39 c3                	cmp    %eax,%ebx
80102bb5:	73 4d                	jae    80102c04 <main+0x10c>
    if(c == mycpu())  // We've started already.
80102bb7:	e8 10 07 00 00       	call   801032cc <mycpu>
80102bbc:	39 c3                	cmp    %eax,%ebx
80102bbe:	74 d8                	je     80102b98 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102bc0:	e8 6f f6 ff ff       	call   80102234 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102bc5:	05 00 10 00 00       	add    $0x1000,%eax
80102bca:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102bcf:	c7 05 f8 6f 00 80 dc 	movl   $0x80102adc,0x80006ff8
80102bd6:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102bd9:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102be0:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102be3:	83 ec 08             	sub    $0x8,%esp
80102be6:	68 00 70 00 00       	push   $0x7000
80102beb:	0f b6 03             	movzbl (%ebx),%eax
80102bee:	50                   	push   %eax
80102bef:	e8 98 f8 ff ff       	call   8010248c <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102bf4:	83 c4 10             	add    $0x10,%esp
80102bf7:	90                   	nop
80102bf8:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102bfe:	85 c0                	test   %eax,%eax
80102c00:	74 f6                	je     80102bf8 <main+0x100>
80102c02:	eb 94                	jmp    80102b98 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102c04:	83 ec 08             	sub    $0x8,%esp
80102c07:	68 00 00 00 8e       	push   $0x8e000000
80102c0c:	68 00 00 40 80       	push   $0x80400000
80102c11:	e8 ca f5 ff ff       	call   801021e0 <kinit2>
  userinit();      // first user process
80102c16:	e8 6d 07 00 00       	call   80103388 <userinit>
  mpmain();        // finish this processor's setup
80102c1b:	e8 80 fe ff ff       	call   80102aa0 <mpmain>

80102c20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c29:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102c2f:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102c36:	39 de                	cmp    %ebx,%esi
80102c38:	72 0b                	jb     80102c45 <mpsearch1+0x25>
80102c3a:	eb 3c                	jmp    80102c78 <mpsearch1+0x58>
80102c3c:	8d 7e 10             	lea    0x10(%esi),%edi
80102c3f:	89 fe                	mov    %edi,%esi
80102c41:	39 fb                	cmp    %edi,%ebx
80102c43:	76 33                	jbe    80102c78 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c45:	50                   	push   %eax
80102c46:	6a 04                	push   $0x4
80102c48:	68 38 6d 10 80       	push   $0x80106d38
80102c4d:	56                   	push   %esi
80102c4e:	e8 55 15 00 00       	call   801041a8 <memcmp>
80102c53:	83 c4 10             	add    $0x10,%esp
80102c56:	85 c0                	test   %eax,%eax
80102c58:	75 e2                	jne    80102c3c <mpsearch1+0x1c>
80102c5a:	89 f2                	mov    %esi,%edx
80102c5c:	8d 7e 10             	lea    0x10(%esi),%edi
80102c5f:	90                   	nop
    sum += addr[i];
80102c60:	0f b6 0a             	movzbl (%edx),%ecx
80102c63:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102c65:	42                   	inc    %edx
80102c66:	39 fa                	cmp    %edi,%edx
80102c68:	75 f6                	jne    80102c60 <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c6a:	84 c0                	test   %al,%al
80102c6c:	75 d1                	jne    80102c3f <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102c6e:	89 f0                	mov    %esi,%eax
80102c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c73:	5b                   	pop    %ebx
80102c74:	5e                   	pop    %esi
80102c75:	5f                   	pop    %edi
80102c76:	5d                   	pop    %ebp
80102c77:	c3                   	ret    
  return 0;
80102c78:	31 f6                	xor    %esi,%esi
}
80102c7a:	89 f0                	mov    %esi,%eax
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    

80102c84 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c84:	55                   	push   %ebp
80102c85:	89 e5                	mov    %esp,%ebp
80102c87:	57                   	push   %edi
80102c88:	56                   	push   %esi
80102c89:	53                   	push   %ebx
80102c8a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c8d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c94:	c1 e0 08             	shl    $0x8,%eax
80102c97:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c9e:	09 d0                	or     %edx,%eax
80102ca0:	c1 e0 04             	shl    $0x4,%eax
80102ca3:	75 1b                	jne    80102cc0 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102ca5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102cac:	c1 e0 08             	shl    $0x8,%eax
80102caf:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cb6:	09 d0                	or     %edx,%eax
80102cb8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cbb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102cc0:	ba 00 04 00 00       	mov    $0x400,%edx
80102cc5:	e8 56 ff ff ff       	call   80102c20 <mpsearch1>
80102cca:	89 c3                	mov    %eax,%ebx
80102ccc:	85 c0                	test   %eax,%eax
80102cce:	0f 84 18 01 00 00    	je     80102dec <mpinit+0x168>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102cd4:	8b 73 04             	mov    0x4(%ebx),%esi
80102cd7:	85 f6                	test   %esi,%esi
80102cd9:	0f 84 29 01 00 00    	je     80102e08 <mpinit+0x184>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102cdf:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102ce5:	50                   	push   %eax
80102ce6:	6a 04                	push   $0x4
80102ce8:	68 3d 6d 10 80       	push   $0x80106d3d
80102ced:	57                   	push   %edi
80102cee:	e8 b5 14 00 00       	call   801041a8 <memcmp>
80102cf3:	83 c4 10             	add    $0x10,%esp
80102cf6:	85 c0                	test   %eax,%eax
80102cf8:	0f 85 0a 01 00 00    	jne    80102e08 <mpinit+0x184>
  if(conf->version != 1 && conf->version != 4)
80102cfe:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102d04:	3c 01                	cmp    $0x1,%al
80102d06:	74 08                	je     80102d10 <mpinit+0x8c>
80102d08:	3c 04                	cmp    $0x4,%al
80102d0a:	0f 85 f8 00 00 00    	jne    80102e08 <mpinit+0x184>
  if(sum((uchar*)conf, conf->length) != 0)
80102d10:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102d17:	66 85 d2             	test   %dx,%dx
80102d1a:	74 1f                	je     80102d3b <mpinit+0xb7>
80102d1c:	89 f8                	mov    %edi,%eax
80102d1e:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
80102d21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  sum = 0;
80102d24:	31 d2                	xor    %edx,%edx
80102d26:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80102d28:	0f b6 08             	movzbl (%eax),%ecx
80102d2b:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102d2d:	40                   	inc    %eax
80102d2e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80102d31:	75 f5                	jne    80102d28 <mpinit+0xa4>
  if(sum((uchar*)conf, conf->length) != 0)
80102d33:	84 d2                	test   %dl,%dl
80102d35:	0f 85 cd 00 00 00    	jne    80102e08 <mpinit+0x184>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d3b:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80102d41:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d46:	8d 96 2c 00 00 80    	lea    -0x7fffffd4(%esi),%edx
80102d4c:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
80102d53:	01 c7                	add    %eax,%edi
  ismp = 1;
80102d55:	b9 01 00 00 00       	mov    $0x1,%ecx
80102d5a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d60:	39 d7                	cmp    %edx,%edi
80102d62:	76 13                	jbe    80102d77 <mpinit+0xf3>
    switch(*p){
80102d64:	8a 02                	mov    (%edx),%al
80102d66:	3c 02                	cmp    $0x2,%al
80102d68:	74 46                	je     80102db0 <mpinit+0x12c>
80102d6a:	77 38                	ja     80102da4 <mpinit+0x120>
80102d6c:	84 c0                	test   %al,%al
80102d6e:	74 50                	je     80102dc0 <mpinit+0x13c>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d70:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d73:	39 d7                	cmp    %edx,%edi
80102d75:	77 ed                	ja     80102d64 <mpinit+0xe0>
80102d77:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d7a:	85 c9                	test   %ecx,%ecx
80102d7c:	0f 84 93 00 00 00    	je     80102e15 <mpinit+0x191>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d82:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80102d86:	74 12                	je     80102d9a <mpinit+0x116>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d88:	b0 70                	mov    $0x70,%al
80102d8a:	ba 22 00 00 00       	mov    $0x22,%edx
80102d8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d90:	ba 23 00 00 00       	mov    $0x23,%edx
80102d95:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d96:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d99:	ee                   	out    %al,(%dx)
  }
}
80102d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9d:	5b                   	pop    %ebx
80102d9e:	5e                   	pop    %esi
80102d9f:	5f                   	pop    %edi
80102da0:	5d                   	pop    %ebp
80102da1:	c3                   	ret    
80102da2:	66 90                	xchg   %ax,%ax
    switch(*p){
80102da4:	83 e8 03             	sub    $0x3,%eax
80102da7:	3c 01                	cmp    $0x1,%al
80102da9:	76 c5                	jbe    80102d70 <mpinit+0xec>
80102dab:	31 c9                	xor    %ecx,%ecx
80102dad:	eb b1                	jmp    80102d60 <mpinit+0xdc>
80102daf:	90                   	nop
      ioapicid = ioapic->apicno;
80102db0:	8a 42 01             	mov    0x1(%edx),%al
80102db3:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102db8:	83 c2 08             	add    $0x8,%edx
      continue;
80102dbb:	eb a3                	jmp    80102d60 <mpinit+0xdc>
80102dbd:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80102dc0:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102dc5:	83 f8 07             	cmp    $0x7,%eax
80102dc8:	7f 19                	jg     80102de3 <mpinit+0x15f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102dca:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102dcd:	01 f6                	add    %esi,%esi
80102dcf:	01 c6                	add    %eax,%esi
80102dd1:	c1 e6 04             	shl    $0x4,%esi
80102dd4:	8a 5a 01             	mov    0x1(%edx),%bl
80102dd7:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102ddd:	40                   	inc    %eax
80102dde:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102de3:	83 c2 14             	add    $0x14,%edx
      continue;
80102de6:	e9 75 ff ff ff       	jmp    80102d60 <mpinit+0xdc>
80102deb:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80102dec:	ba 00 00 01 00       	mov    $0x10000,%edx
80102df1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102df6:	e8 25 fe ff ff       	call   80102c20 <mpsearch1>
80102dfb:	89 c3                	mov    %eax,%ebx
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102dfd:	85 c0                	test   %eax,%eax
80102dff:	0f 85 cf fe ff ff    	jne    80102cd4 <mpinit+0x50>
80102e05:	8d 76 00             	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	68 42 6d 10 80       	push   $0x80106d42
80102e10:	e8 2b d5 ff ff       	call   80100340 <panic>
    panic("Didn't find a suitable machine");
80102e15:	83 ec 0c             	sub    $0xc,%esp
80102e18:	68 5c 6d 10 80       	push   $0x80106d5c
80102e1d:	e8 1e d5 ff ff       	call   80100340 <panic>
80102e22:	66 90                	xchg   %ax,%ax

80102e24 <picinit>:
80102e24:	b0 ff                	mov    $0xff,%al
80102e26:	ba 21 00 00 00       	mov    $0x21,%edx
80102e2b:	ee                   	out    %al,(%dx)
80102e2c:	ba a1 00 00 00       	mov    $0xa1,%edx
80102e31:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102e32:	c3                   	ret    
80102e33:	90                   	nop

80102e34 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	57                   	push   %edi
80102e38:	56                   	push   %esi
80102e39:	53                   	push   %ebx
80102e3a:	83 ec 0c             	sub    $0xc,%esp
80102e3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e40:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e43:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e49:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e4f:	e8 a4 de ff ff       	call   80100cf8 <filealloc>
80102e54:	89 03                	mov    %eax,(%ebx)
80102e56:	85 c0                	test   %eax,%eax
80102e58:	0f 84 a8 00 00 00    	je     80102f06 <pipealloc+0xd2>
80102e5e:	e8 95 de ff ff       	call   80100cf8 <filealloc>
80102e63:	89 06                	mov    %eax,(%esi)
80102e65:	85 c0                	test   %eax,%eax
80102e67:	0f 84 87 00 00 00    	je     80102ef4 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e6d:	e8 c2 f3 ff ff       	call   80102234 <kalloc>
80102e72:	89 c7                	mov    %eax,%edi
80102e74:	85 c0                	test   %eax,%eax
80102e76:	0f 84 ac 00 00 00    	je     80102f28 <pipealloc+0xf4>
    goto bad;
  p->readopen = 1;
80102e7c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e83:	00 00 00 
  p->writeopen = 1;
80102e86:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e8d:	00 00 00 
  p->nwrite = 0;
80102e90:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e97:	00 00 00 
  p->nread = 0;
80102e9a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ea1:	00 00 00 
  initlock(&p->lock, "pipe");
80102ea4:	83 ec 08             	sub    $0x8,%esp
80102ea7:	68 7b 6d 10 80       	push   $0x80106d7b
80102eac:	50                   	push   %eax
80102ead:	e8 8a 10 00 00       	call   80103f3c <initlock>
  (*f0)->type = FD_PIPE;
80102eb2:	8b 03                	mov    (%ebx),%eax
80102eb4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102eba:	8b 03                	mov    (%ebx),%eax
80102ebc:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102ec0:	8b 03                	mov    (%ebx),%eax
80102ec2:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102ec6:	8b 03                	mov    (%ebx),%eax
80102ec8:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102ecb:	8b 06                	mov    (%esi),%eax
80102ecd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102ed3:	8b 06                	mov    (%esi),%eax
80102ed5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102ed9:	8b 06                	mov    (%esi),%eax
80102edb:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102edf:	8b 06                	mov    (%esi),%eax
80102ee1:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ee4:	83 c4 10             	add    $0x10,%esp
80102ee7:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80102ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eec:	5b                   	pop    %ebx
80102eed:	5e                   	pop    %esi
80102eee:	5f                   	pop    %edi
80102eef:	5d                   	pop    %ebp
80102ef0:	c3                   	ret    
80102ef1:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80102ef4:	8b 03                	mov    (%ebx),%eax
80102ef6:	85 c0                	test   %eax,%eax
80102ef8:	74 1e                	je     80102f18 <pipealloc+0xe4>
    fileclose(*f0);
80102efa:	83 ec 0c             	sub    $0xc,%esp
80102efd:	50                   	push   %eax
80102efe:	e8 99 de ff ff       	call   80100d9c <fileclose>
80102f03:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f06:	8b 06                	mov    (%esi),%eax
80102f08:	85 c0                	test   %eax,%eax
80102f0a:	74 0c                	je     80102f18 <pipealloc+0xe4>
    fileclose(*f1);
80102f0c:	83 ec 0c             	sub    $0xc,%esp
80102f0f:	50                   	push   %eax
80102f10:	e8 87 de ff ff       	call   80100d9c <fileclose>
80102f15:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f20:	5b                   	pop    %ebx
80102f21:	5e                   	pop    %esi
80102f22:	5f                   	pop    %edi
80102f23:	5d                   	pop    %ebp
80102f24:	c3                   	ret    
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80102f28:	8b 03                	mov    (%ebx),%eax
80102f2a:	85 c0                	test   %eax,%eax
80102f2c:	75 cc                	jne    80102efa <pipealloc+0xc6>
80102f2e:	eb d6                	jmp    80102f06 <pipealloc+0xd2>

80102f30 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
80102f34:	53                   	push   %ebx
80102f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f38:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80102f3b:	83 ec 0c             	sub    $0xc,%esp
80102f3e:	53                   	push   %ebx
80102f3f:	e8 38 11 00 00       	call   8010407c <acquire>
  if(writable){
80102f44:	83 c4 10             	add    $0x10,%esp
80102f47:	85 f6                	test   %esi,%esi
80102f49:	74 41                	je     80102f8c <pipeclose+0x5c>
    p->writeopen = 0;
80102f4b:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f52:	00 00 00 
    wakeup(&p->nread);
80102f55:	83 ec 0c             	sub    $0xc,%esp
80102f58:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f5e:	50                   	push   %eax
80102f5f:	e8 64 0c 00 00       	call   80103bc8 <wakeup>
80102f64:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f67:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80102f6d:	85 d2                	test   %edx,%edx
80102f6f:	75 0a                	jne    80102f7b <pipeclose+0x4b>
80102f71:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80102f77:	85 c0                	test   %eax,%eax
80102f79:	74 31                	je     80102fac <pipeclose+0x7c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f81:	5b                   	pop    %ebx
80102f82:	5e                   	pop    %esi
80102f83:	5d                   	pop    %ebp
    release(&p->lock);
80102f84:	e9 8b 11 00 00       	jmp    80104114 <release>
80102f89:	8d 76 00             	lea    0x0(%esi),%esi
    p->readopen = 0;
80102f8c:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f93:	00 00 00 
    wakeup(&p->nwrite);
80102f96:	83 ec 0c             	sub    $0xc,%esp
80102f99:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f9f:	50                   	push   %eax
80102fa0:	e8 23 0c 00 00       	call   80103bc8 <wakeup>
80102fa5:	83 c4 10             	add    $0x10,%esp
80102fa8:	eb bd                	jmp    80102f67 <pipeclose+0x37>
80102faa:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80102fac:	83 ec 0c             	sub    $0xc,%esp
80102faf:	53                   	push   %ebx
80102fb0:	e8 5f 11 00 00       	call   80104114 <release>
    kfree((char*)p);
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102fbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fbe:	5b                   	pop    %ebx
80102fbf:	5e                   	pop    %esi
80102fc0:	5d                   	pop    %ebp
    kfree((char*)p);
80102fc1:	e9 de f0 ff ff       	jmp    801020a4 <kfree>
80102fc6:	66 90                	xchg   %ax,%ax

80102fc8 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102fc8:	55                   	push   %ebp
80102fc9:	89 e5                	mov    %esp,%ebp
80102fcb:	57                   	push   %edi
80102fcc:	56                   	push   %esi
80102fcd:	53                   	push   %ebx
80102fce:	83 ec 28             	sub    $0x28,%esp
80102fd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fd4:	53                   	push   %ebx
80102fd5:	e8 a2 10 00 00       	call   8010407c <acquire>
  for(i = 0; i < n; i++){
80102fda:	83 c4 10             	add    $0x10,%esp
80102fdd:	8b 45 10             	mov    0x10(%ebp),%eax
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	0f 8e b1 00 00 00    	jle    80103099 <pipewrite+0xd1>
80102fe8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ff1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102ff4:	03 4d 10             	add    0x10(%ebp),%ecx
80102ff7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102ffa:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103000:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103006:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010300c:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103012:	39 d0                	cmp    %edx,%eax
80103014:	74 38                	je     8010304e <pipewrite+0x86>
80103016:	eb 59                	jmp    80103071 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103018:	e8 47 03 00 00       	call   80103364 <myproc>
8010301d:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103020:	85 c9                	test   %ecx,%ecx
80103022:	75 34                	jne    80103058 <pipewrite+0x90>
      wakeup(&p->nread);
80103024:	83 ec 0c             	sub    $0xc,%esp
80103027:	57                   	push   %edi
80103028:	e8 9b 0b 00 00       	call   80103bc8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010302d:	58                   	pop    %eax
8010302e:	5a                   	pop    %edx
8010302f:	53                   	push   %ebx
80103030:	56                   	push   %esi
80103031:	e8 de 09 00 00       	call   80103a14 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103036:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010303c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103042:	05 00 02 00 00       	add    $0x200,%eax
80103047:	83 c4 10             	add    $0x10,%esp
8010304a:	39 c2                	cmp    %eax,%edx
8010304c:	75 26                	jne    80103074 <pipewrite+0xac>
      if(p->readopen == 0 || myproc()->killed){
8010304e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	75 c0                	jne    80103018 <pipewrite+0x50>
        release(&p->lock);
80103058:	83 ec 0c             	sub    $0xc,%esp
8010305b:	53                   	push   %ebx
8010305c:	e8 b3 10 00 00       	call   80104114 <release>
        return -1;
80103061:	83 c4 10             	add    $0x10,%esp
80103064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010306c:	5b                   	pop    %ebx
8010306d:	5e                   	pop    %esi
8010306e:	5f                   	pop    %edi
8010306f:	5d                   	pop    %ebp
80103070:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103071:	89 c2                	mov    %eax,%edx
80103073:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103074:	8d 42 01             	lea    0x1(%edx),%eax
80103077:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010307d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103080:	8a 0e                	mov    (%esi),%cl
80103082:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103088:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010308c:	46                   	inc    %esi
8010308d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103090:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103093:	0f 85 67 ff ff ff    	jne    80103000 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103099:	83 ec 0c             	sub    $0xc,%esp
8010309c:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030a2:	50                   	push   %eax
801030a3:	e8 20 0b 00 00       	call   80103bc8 <wakeup>
  release(&p->lock);
801030a8:	89 1c 24             	mov    %ebx,(%esp)
801030ab:	e8 64 10 00 00       	call   80104114 <release>
  return n;
801030b0:	83 c4 10             	add    $0x10,%esp
801030b3:	8b 45 10             	mov    0x10(%ebp),%eax
801030b6:	eb b1                	jmp    80103069 <pipewrite+0xa1>

801030b8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030b8:	55                   	push   %ebp
801030b9:	89 e5                	mov    %esp,%ebp
801030bb:	57                   	push   %edi
801030bc:	56                   	push   %esi
801030bd:	53                   	push   %ebx
801030be:	83 ec 18             	sub    $0x18,%esp
801030c1:	8b 75 08             	mov    0x8(%ebp),%esi
801030c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801030c7:	56                   	push   %esi
801030c8:	e8 af 0f 00 00       	call   8010407c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801030d6:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801030dc:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801030e2:	74 2f                	je     80103113 <piperead+0x5b>
801030e4:	eb 37                	jmp    8010311d <piperead+0x65>
801030e6:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801030e8:	e8 77 02 00 00       	call   80103364 <myproc>
801030ed:	8b 48 2c             	mov    0x2c(%eax),%ecx
801030f0:	85 c9                	test   %ecx,%ecx
801030f2:	0f 85 80 00 00 00    	jne    80103178 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030f8:	83 ec 08             	sub    $0x8,%esp
801030fb:	56                   	push   %esi
801030fc:	53                   	push   %ebx
801030fd:	e8 12 09 00 00       	call   80103a14 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103102:	83 c4 10             	add    $0x10,%esp
80103105:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
8010310b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103111:	75 0a                	jne    8010311d <piperead+0x65>
80103113:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103119:	85 c0                	test   %eax,%eax
8010311b:	75 cb                	jne    801030e8 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010311d:	31 db                	xor    %ebx,%ebx
8010311f:	8b 55 10             	mov    0x10(%ebp),%edx
80103122:	85 d2                	test   %edx,%edx
80103124:	7f 1d                	jg     80103143 <piperead+0x8b>
80103126:	eb 29                	jmp    80103151 <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103128:	8d 48 01             	lea    0x1(%eax),%ecx
8010312b:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103131:	25 ff 01 00 00       	and    $0x1ff,%eax
80103136:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
8010313a:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010313d:	43                   	inc    %ebx
8010313e:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103141:	74 0e                	je     80103151 <piperead+0x99>
    if(p->nread == p->nwrite)
80103143:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103149:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010314f:	75 d7                	jne    80103128 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103151:	83 ec 0c             	sub    $0xc,%esp
80103154:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
8010315a:	50                   	push   %eax
8010315b:	e8 68 0a 00 00       	call   80103bc8 <wakeup>
  release(&p->lock);
80103160:	89 34 24             	mov    %esi,(%esp)
80103163:	e8 ac 0f 00 00       	call   80104114 <release>
  return i;
80103168:	83 c4 10             	add    $0x10,%esp
}
8010316b:	89 d8                	mov    %ebx,%eax
8010316d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103170:	5b                   	pop    %ebx
80103171:	5e                   	pop    %esi
80103172:	5f                   	pop    %edi
80103173:	5d                   	pop    %ebp
80103174:	c3                   	ret    
80103175:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
80103178:	83 ec 0c             	sub    $0xc,%esp
8010317b:	56                   	push   %esi
8010317c:	e8 93 0f 00 00       	call   80104114 <release>
      return -1;
80103181:	83 c4 10             	add    $0x10,%esp
80103184:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80103189:	89 d8                	mov    %ebx,%eax
8010318b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318e:	5b                   	pop    %ebx
8010318f:	5e                   	pop    %esi
80103190:	5f                   	pop    %edi
80103191:	5d                   	pop    %ebp
80103192:	c3                   	ret    
80103193:	90                   	nop

80103194 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80103194:	55                   	push   %ebp
80103195:	89 e5                	mov    %esp,%ebp
80103197:	53                   	push   %ebx
80103198:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010319b:	68 20 2d 11 80       	push   $0x80112d20
801031a0:	e8 d7 0e 00 00       	call   8010407c <acquire>
801031a5:	83 c4 10             	add    $0x10,%esp

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031a8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801031ad:	eb 0f                	jmp    801031be <allocproc+0x2a>
801031af:	90                   	nop
801031b0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801031b6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801031bc:	74 7e                	je     8010323c <allocproc+0xa8>
    if (p->state == UNUSED)
801031be:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801031c1:	85 c9                	test   %ecx,%ecx
801031c3:	75 eb                	jne    801031b0 <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801031c5:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031cc:	a1 08 a0 10 80       	mov    0x8010a008,%eax
801031d1:	8d 50 01             	lea    0x1(%eax),%edx
801031d4:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
801031da:	89 43 18             	mov    %eax,0x18(%ebx)
  p->tickets = 1;
801031dd:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)

  release(&ptable.lock);
801031e4:	83 ec 0c             	sub    $0xc,%esp
801031e7:	68 20 2d 11 80       	push   $0x80112d20
801031ec:	e8 23 0f 00 00       	call   80104114 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
801031f1:	e8 3e f0 ff ff       	call   80102234 <kalloc>
801031f6:	89 43 08             	mov    %eax,0x8(%ebx)
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	74 55                	je     80103255 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103200:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103206:	89 53 20             	mov    %edx,0x20(%ebx)
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;
80103209:	c7 80 b0 0f 00 00 37 	movl   $0x80105137,0xfb0(%eax)
80103210:	51 10 80 

  sp -= sizeof *p->context;
80103213:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context *)sp;
80103218:	89 43 24             	mov    %eax,0x24(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010321b:	52                   	push   %edx
8010321c:	6a 14                	push   $0x14
8010321e:	6a 00                	push   $0x0
80103220:	50                   	push   %eax
80103221:	e8 36 0f 00 00       	call   8010415c <memset>
  p->context->eip = (uint)forkret;
80103226:	8b 43 24             	mov    0x24(%ebx),%eax
80103229:	c7 40 10 68 32 10 80 	movl   $0x80103268,0x10(%eax)

  return p;
80103230:	83 c4 10             	add    $0x10,%esp
}
80103233:	89 d8                	mov    %ebx,%eax
80103235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103238:	c9                   	leave  
80103239:	c3                   	ret    
8010323a:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
8010323c:	83 ec 0c             	sub    $0xc,%esp
8010323f:	68 20 2d 11 80       	push   $0x80112d20
80103244:	e8 cb 0e 00 00       	call   80104114 <release>
  return 0;
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	31 db                	xor    %ebx,%ebx
}
8010324e:	89 d8                	mov    %ebx,%eax
80103250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103253:	c9                   	leave  
80103254:	c3                   	ret    
    p->state = UNUSED;
80103255:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010325c:	31 db                	xor    %ebx,%ebx
}
8010325e:	89 d8                	mov    %ebx,%eax
80103260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103263:	c9                   	leave  
80103264:	c3                   	ret    
80103265:	8d 76 00             	lea    0x0(%esi),%esi

80103268 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103268:	55                   	push   %ebp
80103269:	89 e5                	mov    %esp,%ebp
8010326b:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010326e:	68 20 2d 11 80       	push   $0x80112d20
80103273:	e8 9c 0e 00 00       	call   80104114 <release>

  if (first)
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103280:	85 c0                	test   %eax,%eax
80103282:	75 04                	jne    80103288 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103284:	c9                   	leave  
80103285:	c3                   	ret    
80103286:	66 90                	xchg   %ax,%ax
    first = 0;
80103288:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010328f:	00 00 00 
    iinit(ROOTDEV);
80103292:	83 ec 0c             	sub    $0xc,%esp
80103295:	6a 01                	push   $0x1
80103297:	e8 dc e0 ff ff       	call   80101378 <iinit>
    initlog(ROOTDEV);
8010329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801032a3:	e8 04 f5 ff ff       	call   801027ac <initlog>
}
801032a8:	83 c4 10             	add    $0x10,%esp
801032ab:	c9                   	leave  
801032ac:	c3                   	ret    
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

801032b0 <pinit>:
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801032b6:	68 80 6d 10 80       	push   $0x80106d80
801032bb:	68 20 2d 11 80       	push   $0x80112d20
801032c0:	e8 77 0c 00 00       	call   80103f3c <initlock>
}
801032c5:	83 c4 10             	add    $0x10,%esp
801032c8:	c9                   	leave  
801032c9:	c3                   	ret    
801032ca:	66 90                	xchg   %ax,%ax

801032cc <mycpu>:
{
801032cc:	55                   	push   %ebp
801032cd:	89 e5                	mov    %esp,%ebp
801032cf:	56                   	push   %esi
801032d0:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032d1:	9c                   	pushf  
801032d2:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801032d3:	f6 c4 02             	test   $0x2,%ah
801032d6:	75 48                	jne    80103320 <mycpu+0x54>
  apicid = lapicid();
801032d8:	e8 7f f1 ff ff       	call   8010245c <lapicid>
  for (i = 0; i < ncpu; ++i)
801032dd:	8b 1d 00 2d 11 80    	mov    0x80112d00,%ebx
801032e3:	85 db                	test   %ebx,%ebx
801032e5:	7e 2c                	jle    80103313 <mycpu+0x47>
801032e7:	31 c9                	xor    %ecx,%ecx
801032e9:	eb 06                	jmp    801032f1 <mycpu+0x25>
801032eb:	90                   	nop
801032ec:	41                   	inc    %ecx
801032ed:	39 d9                	cmp    %ebx,%ecx
801032ef:	74 22                	je     80103313 <mycpu+0x47>
    if (cpus[i].apicid == apicid)
801032f1:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801032f4:	01 d2                	add    %edx,%edx
801032f6:	01 ca                	add    %ecx,%edx
801032f8:	c1 e2 04             	shl    $0x4,%edx
801032fb:	0f b6 b2 80 27 11 80 	movzbl -0x7feed880(%edx),%esi
80103302:	39 c6                	cmp    %eax,%esi
80103304:	75 e6                	jne    801032ec <mycpu+0x20>
      return &cpus[i];
80103306:	8d 82 80 27 11 80    	lea    -0x7feed880(%edx),%eax
}
8010330c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010330f:	5b                   	pop    %ebx
80103310:	5e                   	pop    %esi
80103311:	5d                   	pop    %ebp
80103312:	c3                   	ret    
  panic("unknown apicid\n");
80103313:	83 ec 0c             	sub    $0xc,%esp
80103316:	68 87 6d 10 80       	push   $0x80106d87
8010331b:	e8 20 d0 ff ff       	call   80100340 <panic>
    panic("mycpu called with interrupts enabled\n");
80103320:	83 ec 0c             	sub    $0xc,%esp
80103323:	68 64 6e 10 80       	push   $0x80106e64
80103328:	e8 13 d0 ff ff       	call   80100340 <panic>
8010332d:	8d 76 00             	lea    0x0(%esi),%esi

80103330 <cpuid>:
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103336:	e8 91 ff ff ff       	call   801032cc <mycpu>
8010333b:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103340:	c1 f8 04             	sar    $0x4,%eax
80103343:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103346:	89 ca                	mov    %ecx,%edx
80103348:	c1 e2 05             	shl    $0x5,%edx
8010334b:	29 ca                	sub    %ecx,%edx
8010334d:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103350:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103353:	89 ca                	mov    %ecx,%edx
80103355:	c1 e2 0f             	shl    $0xf,%edx
80103358:	29 ca                	sub    %ecx,%edx
8010335a:	8d 04 90             	lea    (%eax,%edx,4),%eax
8010335d:	f7 d8                	neg    %eax
}
8010335f:	c9                   	leave  
80103360:	c3                   	ret    
80103361:	8d 76 00             	lea    0x0(%esi),%esi

80103364 <myproc>:
{
80103364:	55                   	push   %ebp
80103365:	89 e5                	mov    %esp,%ebp
80103367:	83 ec 18             	sub    $0x18,%esp
  pushcli();
8010336a:	e8 31 0c 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
8010336f:	e8 58 ff ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103374:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010337a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010337d:	e8 66 0c 00 00       	call   80103fe8 <popcli>
}
80103382:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103385:	c9                   	leave  
80103386:	c3                   	ret    
80103387:	90                   	nop

80103388 <userinit>:
{
80103388:	55                   	push   %ebp
80103389:	89 e5                	mov    %esp,%ebp
8010338b:	53                   	push   %ebx
8010338c:	51                   	push   %ecx
  p = allocproc();
8010338d:	e8 02 fe ff ff       	call   80103194 <allocproc>
80103392:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103394:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if ((p->pgdir = setupkvm()) == 0)
80103399:	e8 32 32 00 00       	call   801065d0 <setupkvm>
8010339e:	89 43 04             	mov    %eax,0x4(%ebx)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 84 b3 00 00 00    	je     8010345c <userinit+0xd4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801033a9:	52                   	push   %edx
801033aa:	68 2c 00 00 00       	push   $0x2c
801033af:	68 60 a4 10 80       	push   $0x8010a460
801033b4:	50                   	push   %eax
801033b5:	e8 32 2f 00 00       	call   801062ec <inituvm>
  p->sz = PGSIZE;
801033ba:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801033c0:	83 c4 0c             	add    $0xc,%esp
801033c3:	6a 4c                	push   $0x4c
801033c5:	6a 00                	push   $0x0
801033c7:	ff 73 20             	pushl  0x20(%ebx)
801033ca:	e8 8d 0d 00 00       	call   8010415c <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033cf:	8b 43 20             	mov    0x20(%ebx),%eax
801033d2:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033d8:	8b 43 20             	mov    0x20(%ebx),%eax
801033db:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033e1:	8b 43 20             	mov    0x20(%ebx),%eax
801033e4:	8b 50 2c             	mov    0x2c(%eax),%edx
801033e7:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033eb:	8b 43 20             	mov    0x20(%ebx),%eax
801033ee:	8b 50 2c             	mov    0x2c(%eax),%edx
801033f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033f5:	8b 43 20             	mov    0x20(%ebx),%eax
801033f8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033ff:	8b 43 20             	mov    0x20(%ebx),%eax
80103402:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103409:	8b 43 20             	mov    0x20(%ebx),%eax
8010340c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103413:	83 c4 0c             	add    $0xc,%esp
80103416:	6a 10                	push   $0x10
80103418:	68 b0 6d 10 80       	push   $0x80106db0
8010341d:	8d 43 74             	lea    0x74(%ebx),%eax
80103420:	50                   	push   %eax
80103421:	e8 8a 0e 00 00       	call   801042b0 <safestrcpy>
  p->cwd = namei("/");
80103426:	c7 04 24 b9 6d 10 80 	movl   $0x80106db9,(%esp)
8010342d:	e8 de e8 ff ff       	call   80101d10 <namei>
80103432:	89 43 70             	mov    %eax,0x70(%ebx)
  acquire(&ptable.lock);
80103435:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010343c:	e8 3b 0c 00 00       	call   8010407c <acquire>
  p->state = RUNNABLE;
80103441:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103448:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010344f:	e8 c0 0c 00 00       	call   80104114 <release>
}
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010345a:	c9                   	leave  
8010345b:	c3                   	ret    
    panic("userinit: out of memory?");
8010345c:	83 ec 0c             	sub    $0xc,%esp
8010345f:	68 97 6d 10 80       	push   $0x80106d97
80103464:	e8 d7 ce ff ff       	call   80100340 <panic>
80103469:	8d 76 00             	lea    0x0(%esi),%esi

8010346c <growproc>:
{
8010346c:	55                   	push   %ebp
8010346d:	89 e5                	mov    %esp,%ebp
8010346f:	56                   	push   %esi
80103470:	53                   	push   %ebx
80103471:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103474:	e8 27 0b 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
80103479:	e8 4e fe ff ff       	call   801032cc <mycpu>
  p = c->proc;
8010347e:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103484:	e8 5f 0b 00 00       	call   80103fe8 <popcli>
  sz = curproc->sz;
80103489:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
8010348b:	85 f6                	test   %esi,%esi
8010348d:	7f 19                	jg     801034a8 <growproc+0x3c>
  else if (n < 0)
8010348f:	75 33                	jne    801034c4 <growproc+0x58>
  curproc->sz = sz;
80103491:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103493:	83 ec 0c             	sub    $0xc,%esp
80103496:	53                   	push   %ebx
80103497:	e8 54 2d 00 00       	call   801061f0 <switchuvm>
  return 0;
8010349c:	83 c4 10             	add    $0x10,%esp
8010349f:	31 c0                	xor    %eax,%eax
}
801034a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5d                   	pop    %ebp
801034a7:	c3                   	ret    
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034a8:	51                   	push   %ecx
801034a9:	01 c6                	add    %eax,%esi
801034ab:	56                   	push   %esi
801034ac:	50                   	push   %eax
801034ad:	ff 73 04             	pushl  0x4(%ebx)
801034b0:	e8 67 2f 00 00       	call   8010641c <allocuvm>
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	85 c0                	test   %eax,%eax
801034ba:	75 d5                	jne    80103491 <growproc+0x25>
      return -1;
801034bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034c1:	eb de                	jmp    801034a1 <growproc+0x35>
801034c3:	90                   	nop
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034c4:	52                   	push   %edx
801034c5:	01 c6                	add    %eax,%esi
801034c7:	56                   	push   %esi
801034c8:	50                   	push   %eax
801034c9:	ff 73 04             	pushl  0x4(%ebx)
801034cc:	e8 73 30 00 00       	call   80106544 <deallocuvm>
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	85 c0                	test   %eax,%eax
801034d6:	75 b9                	jne    80103491 <growproc+0x25>
801034d8:	eb e2                	jmp    801034bc <growproc+0x50>
801034da:	66 90                	xchg   %ax,%ax

801034dc <fork>:
{
801034dc:	55                   	push   %ebp
801034dd:	89 e5                	mov    %esp,%ebp
801034df:	57                   	push   %edi
801034e0:	56                   	push   %esi
801034e1:	53                   	push   %ebx
801034e2:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801034e5:	e8 b6 0a 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
801034ea:	e8 dd fd ff ff       	call   801032cc <mycpu>
  p = c->proc;
801034ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801034f5:	e8 ee 0a 00 00       	call   80103fe8 <popcli>
  if ((np = allocproc()) == 0)
801034fa:	e8 95 fc ff ff       	call   80103194 <allocproc>
801034ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103502:	85 c0                	test   %eax,%eax
80103504:	0f 84 bd 00 00 00    	je     801035c7 <fork+0xeb>
8010350a:	89 c7                	mov    %eax,%edi
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
8010350c:	83 ec 08             	sub    $0x8,%esp
8010350f:	ff 33                	pushl  (%ebx)
80103511:	ff 73 04             	pushl  0x4(%ebx)
80103514:	e8 73 31 00 00       	call   8010668c <copyuvm>
80103519:	89 47 04             	mov    %eax,0x4(%edi)
8010351c:	83 c4 10             	add    $0x10,%esp
8010351f:	85 c0                	test   %eax,%eax
80103521:	0f 84 a7 00 00 00    	je     801035ce <fork+0xf2>
  np->sz = curproc->sz;
80103527:	8b 03                	mov    (%ebx),%eax
80103529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010352c:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
8010352e:	89 5a 1c             	mov    %ebx,0x1c(%edx)
  *np->tf = *curproc->tf;
80103531:	8b 73 20             	mov    0x20(%ebx),%esi
80103534:	8b 7a 20             	mov    0x20(%edx),%edi
80103537:	b9 13 00 00 00       	mov    $0x13,%ecx
8010353c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tickets = curproc->tickets;
8010353e:	8b 43 10             	mov    0x10(%ebx),%eax
80103541:	89 42 10             	mov    %eax,0x10(%edx)
  np->tf->eax = 0;
80103544:	8b 42 20             	mov    0x20(%edx),%eax
80103547:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
8010354e:	31 f6                	xor    %esi,%esi
    if (curproc->ofile[i])
80103550:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
80103554:	85 c0                	test   %eax,%eax
80103556:	74 13                	je     8010356b <fork+0x8f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103558:	83 ec 0c             	sub    $0xc,%esp
8010355b:	50                   	push   %eax
8010355c:	e8 f7 d7 ff ff       	call   80100d58 <filedup>
80103561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103564:	89 44 b2 30          	mov    %eax,0x30(%edx,%esi,4)
80103568:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < NOFILE; i++)
8010356b:	46                   	inc    %esi
8010356c:	83 fe 10             	cmp    $0x10,%esi
8010356f:	75 df                	jne    80103550 <fork+0x74>
  np->cwd = idup(curproc->cwd);
80103571:	83 ec 0c             	sub    $0xc,%esp
80103574:	ff 73 70             	pushl  0x70(%ebx)
80103577:	e8 b4 df ff ff       	call   80101530 <idup>
8010357c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010357f:	89 47 70             	mov    %eax,0x70(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103582:	83 c4 0c             	add    $0xc,%esp
80103585:	6a 10                	push   $0x10
80103587:	83 c3 74             	add    $0x74,%ebx
8010358a:	53                   	push   %ebx
8010358b:	8d 47 74             	lea    0x74(%edi),%eax
8010358e:	50                   	push   %eax
8010358f:	e8 1c 0d 00 00       	call   801042b0 <safestrcpy>
  pid = np->pid;
80103594:	8b 47 18             	mov    0x18(%edi),%eax
80103597:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
8010359a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035a1:	e8 d6 0a 00 00       	call   8010407c <acquire>
  np->state = RUNNABLE;
801035a6:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801035ad:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035b4:	e8 5b 0b 00 00       	call   80104114 <release>
  return pid;
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801035bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5f                   	pop    %edi
801035c5:	5d                   	pop    %ebp
801035c6:	c3                   	ret    
    return -1;
801035c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035cc:	eb f1                	jmp    801035bf <fork+0xe3>
    kfree(np->kstack);
801035ce:	83 ec 0c             	sub    $0xc,%esp
801035d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801035d4:	ff 73 08             	pushl  0x8(%ebx)
801035d7:	e8 c8 ea ff ff       	call   801020a4 <kfree>
    np->kstack = 0;
801035dc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801035e3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801035ea:	83 c4 10             	add    $0x10,%esp
801035ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f2:	eb cb                	jmp    801035bf <fork+0xe3>

801035f4 <random>:
  val = (1103515245U * val + 12345U) & 0x7fffffff;
801035f4:	8b 15 04 a0 10 80    	mov    0x8010a004,%edx
801035fa:	89 d0                	mov    %edx,%eax
801035fc:	c1 e0 09             	shl    $0x9,%eax
801035ff:	29 d0                	sub    %edx,%eax
80103601:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
80103604:	89 c8                	mov    %ecx,%eax
80103606:	c1 e0 09             	shl    $0x9,%eax
80103609:	29 c8                	sub    %ecx,%eax
8010360b:	01 c0                	add    %eax,%eax
8010360d:	01 d0                	add    %edx,%eax
8010360f:	89 c1                	mov    %eax,%ecx
80103611:	c1 e1 05             	shl    $0x5,%ecx
80103614:	01 c8                	add    %ecx,%eax
80103616:	c1 e0 02             	shl    $0x2,%eax
80103619:	29 d0                	sub    %edx,%eax
8010361b:	8d 84 82 39 30 00 00 	lea    0x3039(%edx,%eax,4),%eax
80103622:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80103627:	a3 04 a0 10 80       	mov    %eax,0x8010a004
}
8010362c:	c3                   	ret    
8010362d:	8d 76 00             	lea    0x0(%esi),%esi

80103630 <getwinner>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
      num_bins = (unsigned long)totaltickets + 1,
80103635:	8b 45 08             	mov    0x8(%ebp),%eax
80103638:	8d 48 01             	lea    0x1(%eax),%ecx
      bin_size = num_rand / num_bins,
8010363b:	be 00 00 00 80       	mov    $0x80000000,%esi
80103640:	89 f0                	mov    %esi,%eax
80103642:	31 d2                	xor    %edx,%edx
80103644:	f7 f1                	div    %ecx
80103646:	89 c3                	mov    %eax,%ebx
80103648:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010364d:	29 d6                	sub    %edx,%esi
8010364f:	90                   	nop
  val = (1103515245U * val + 12345U) & 0x7fffffff;
80103650:	89 c2                	mov    %eax,%edx
80103652:	c1 e2 09             	shl    $0x9,%edx
80103655:	29 c2                	sub    %eax,%edx
80103657:	8d 14 90             	lea    (%eax,%edx,4),%edx
8010365a:	89 d1                	mov    %edx,%ecx
8010365c:	c1 e1 09             	shl    $0x9,%ecx
8010365f:	29 d1                	sub    %edx,%ecx
80103661:	01 c9                	add    %ecx,%ecx
80103663:	01 c1                	add    %eax,%ecx
80103665:	89 ca                	mov    %ecx,%edx
80103667:	c1 e2 05             	shl    $0x5,%edx
8010366a:	01 d1                	add    %edx,%ecx
8010366c:	c1 e1 02             	shl    $0x2,%ecx
8010366f:	29 c1                	sub    %eax,%ecx
80103671:	8d 84 88 39 30 00 00 	lea    0x3039(%eax,%ecx,4),%eax
80103678:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  while (num_rand - defect <= (unsigned long)x);
8010367d:	39 f0                	cmp    %esi,%eax
8010367f:	73 cf                	jae    80103650 <getwinner+0x20>
80103681:	a3 04 a0 10 80       	mov    %eax,0x8010a004
  return x / bin_size;
80103686:	31 d2                	xor    %edx,%edx
80103688:	f7 f3                	div    %ebx
}
8010368a:	5b                   	pop    %ebx
8010368b:	5e                   	pop    %esi
8010368c:	5d                   	pop    %ebp
8010368d:	c3                   	ret    
8010368e:	66 90                	xchg   %ax,%ax

80103690 <scheduler>:
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103699:	e8 2e fc ff ff       	call   801032cc <mycpu>
8010369e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c->proc = 0;
801036a1:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801036a8:	00 00 00 
801036ab:	83 c0 04             	add    $0x4,%eax
801036ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
801036b1:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801036b4:	fb                   	sti    
    acquire(&ptable.lock);
801036b5:	83 ec 0c             	sub    $0xc,%esp
801036b8:	68 20 2d 11 80       	push   $0x80112d20
801036bd:	e8 ba 09 00 00       	call   8010407c <acquire>
801036c2:	83 c4 10             	add    $0x10,%esp
    int totaltickets = 0;
801036c5:	31 d2                	xor    %edx,%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
      if (p->state == RUNNABLE)
801036cc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801036d0:	75 03                	jne    801036d5 <scheduler+0x45>
        totaltickets += p->tickets;
801036d2:	03 50 10             	add    0x10(%eax),%edx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036d5:	05 84 00 00 00       	add    $0x84,%eax
801036da:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801036df:	75 eb                	jne    801036cc <scheduler+0x3c>
      num_bins = (unsigned long)totaltickets + 1,
801036e1:	8d 4a 01             	lea    0x1(%edx),%ecx
      bin_size = num_rand / num_bins,
801036e4:	b8 00 00 00 80       	mov    $0x80000000,%eax
801036e9:	31 d2                	xor    %edx,%edx
801036eb:	f7 f1                	div    %ecx
801036ed:	89 c7                	mov    %eax,%edi
801036ef:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801036f4:	be 00 00 00 80       	mov    $0x80000000,%esi
801036f9:	29 d6                	sub    %edx,%esi
801036fb:	89 f2                	mov    %esi,%edx
801036fd:	8d 76 00             	lea    0x0(%esi),%esi
  val = (1103515245U * val + 12345U) & 0x7fffffff;
80103700:	89 c1                	mov    %eax,%ecx
80103702:	c1 e1 09             	shl    $0x9,%ecx
80103705:	29 c1                	sub    %eax,%ecx
80103707:	8d 1c 88             	lea    (%eax,%ecx,4),%ebx
8010370a:	89 d9                	mov    %ebx,%ecx
8010370c:	c1 e1 09             	shl    $0x9,%ecx
8010370f:	29 d9                	sub    %ebx,%ecx
80103711:	01 c9                	add    %ecx,%ecx
80103713:	01 c1                	add    %eax,%ecx
80103715:	89 cb                	mov    %ecx,%ebx
80103717:	c1 e3 05             	shl    $0x5,%ebx
8010371a:	01 d9                	add    %ebx,%ecx
8010371c:	c1 e1 02             	shl    $0x2,%ecx
8010371f:	29 c1                	sub    %eax,%ecx
80103721:	8d 84 88 39 30 00 00 	lea    0x3039(%eax,%ecx,4),%eax
80103728:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  while (num_rand - defect <= (unsigned long)x);
8010372d:	39 d0                	cmp    %edx,%eax
8010372f:	73 cf                	jae    80103700 <scheduler+0x70>
80103731:	a3 04 a0 10 80       	mov    %eax,0x8010a004
  return x / bin_size;
80103736:	31 d2                	xor    %edx,%edx
80103738:	f7 f7                	div    %edi
8010373a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int counter = 0;
8010373d:	31 f6                	xor    %esi,%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010373f:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103744:	89 f7                	mov    %esi,%edi
80103746:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80103748:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010374c:	75 7a                	jne    801037c8 <scheduler+0x138>
      counter += p->tickets;
8010374e:	03 7b 10             	add    0x10(%ebx),%edi
      if (counter <= winner)
80103751:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80103754:	7e 72                	jle    801037c8 <scheduler+0x138>
      uint ticks0 = ticks;
80103756:	8b 35 a0 56 11 80    	mov    0x801156a0,%esi
      c->proc = p;
8010375c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010375f:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
      switchuvm(p);
80103765:	83 ec 0c             	sub    $0xc,%esp
80103768:	53                   	push   %ebx
80103769:	e8 82 2a 00 00       	call   801061f0 <switchuvm>
      p->state = RUNNING;
8010376e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103775:	58                   	pop    %eax
80103776:	5a                   	pop    %edx
80103777:	ff 73 24             	pushl  0x24(%ebx)
8010377a:	ff 75 dc             	pushl  -0x24(%ebp)
8010377d:	e8 7b 0b 00 00       	call   801042fd <swtch>
      switchkvm();
80103782:	e8 59 2a 00 00       	call   801061e0 <switchkvm>
      c->proc = 0;
80103787:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010378a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103791:	00 00 00 
      p->ticks += (ticks - ticks0);
80103794:	8b 15 a0 56 11 80    	mov    0x801156a0,%edx
8010379a:	29 f2                	sub    %esi,%edx
8010379c:	03 53 14             	add    0x14(%ebx),%edx
8010379f:	89 53 14             	mov    %edx,0x14(%ebx)
      if (p->tickets > 1)
801037a2:	8b 73 10             	mov    0x10(%ebx),%esi
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	83 fe 01             	cmp    $0x1,%esi
801037ab:	7e 1b                	jle    801037c8 <scheduler+0x138>
        cprintf("XV6_TEST_OUTPUT pid: %d, parent: %d, tickets:%d, ticks: %d\n",
801037ad:	83 ec 0c             	sub    $0xc,%esp
801037b0:	52                   	push   %edx
801037b1:	56                   	push   %esi
801037b2:	8b 53 1c             	mov    0x1c(%ebx),%edx
801037b5:	ff 72 18             	pushl  0x18(%edx)
801037b8:	ff 73 18             	pushl  0x18(%ebx)
801037bb:	68 8c 6e 10 80       	push   $0x80106e8c
801037c0:	e8 5b ce ff ff       	call   80100620 <cprintf>
801037c5:	83 c4 20             	add    $0x20,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801037ce:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801037d4:	0f 85 6e ff ff ff    	jne    80103748 <scheduler+0xb8>
    release(&ptable.lock);
801037da:	83 ec 0c             	sub    $0xc,%esp
801037dd:	68 20 2d 11 80       	push   $0x80112d20
801037e2:	e8 2d 09 00 00       	call   80104114 <release>
  {
801037e7:	83 c4 10             	add    $0x10,%esp
801037ea:	e9 c5 fe ff ff       	jmp    801036b4 <scheduler+0x24>
801037ef:	90                   	nop

801037f0 <sched>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
  pushcli();
801037f5:	e8 a6 07 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
801037fa:	e8 cd fa ff ff       	call   801032cc <mycpu>
  p = c->proc;
801037ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103805:	e8 de 07 00 00       	call   80103fe8 <popcli>
  if (!holding(&ptable.lock))
8010380a:	83 ec 0c             	sub    $0xc,%esp
8010380d:	68 20 2d 11 80       	push   $0x80112d20
80103812:	e8 29 08 00 00       	call   80104040 <holding>
80103817:	83 c4 10             	add    $0x10,%esp
8010381a:	85 c0                	test   %eax,%eax
8010381c:	74 4f                	je     8010386d <sched+0x7d>
  if (mycpu()->ncli != 1)
8010381e:	e8 a9 fa ff ff       	call   801032cc <mycpu>
80103823:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010382a:	75 68                	jne    80103894 <sched+0xa4>
  if (p->state == RUNNING)
8010382c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103830:	74 55                	je     80103887 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103832:	9c                   	pushf  
80103833:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103834:	f6 c4 02             	test   $0x2,%ah
80103837:	75 41                	jne    8010387a <sched+0x8a>
  intena = mycpu()->intena;
80103839:	e8 8e fa ff ff       	call   801032cc <mycpu>
8010383e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103844:	e8 83 fa ff ff       	call   801032cc <mycpu>
80103849:	83 ec 08             	sub    $0x8,%esp
8010384c:	ff 70 04             	pushl  0x4(%eax)
8010384f:	83 c3 24             	add    $0x24,%ebx
80103852:	53                   	push   %ebx
80103853:	e8 a5 0a 00 00       	call   801042fd <swtch>
  mycpu()->intena = intena;
80103858:	e8 6f fa ff ff       	call   801032cc <mycpu>
8010385d:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103863:	83 c4 10             	add    $0x10,%esp
80103866:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103869:	5b                   	pop    %ebx
8010386a:	5e                   	pop    %esi
8010386b:	5d                   	pop    %ebp
8010386c:	c3                   	ret    
    panic("sched ptable.lock");
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	68 bb 6d 10 80       	push   $0x80106dbb
80103875:	e8 c6 ca ff ff       	call   80100340 <panic>
    panic("sched interruptible");
8010387a:	83 ec 0c             	sub    $0xc,%esp
8010387d:	68 e7 6d 10 80       	push   $0x80106de7
80103882:	e8 b9 ca ff ff       	call   80100340 <panic>
    panic("sched running");
80103887:	83 ec 0c             	sub    $0xc,%esp
8010388a:	68 d9 6d 10 80       	push   $0x80106dd9
8010388f:	e8 ac ca ff ff       	call   80100340 <panic>
    panic("sched locks");
80103894:	83 ec 0c             	sub    $0xc,%esp
80103897:	68 cd 6d 10 80       	push   $0x80106dcd
8010389c:	e8 9f ca ff ff       	call   80100340 <panic>
801038a1:	8d 76 00             	lea    0x0(%esi),%esi

801038a4 <exit>:
{
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	57                   	push   %edi
801038a8:	56                   	push   %esi
801038a9:	53                   	push   %ebx
801038aa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801038ad:	e8 ee 06 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
801038b2:	e8 15 fa ff ff       	call   801032cc <mycpu>
  p = c->proc;
801038b7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801038bd:	e8 26 07 00 00       	call   80103fe8 <popcli>
  if (curproc == initproc)
801038c2:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
801038c8:	0f 84 ef 00 00 00    	je     801039bd <exit+0x119>
801038ce:	8d 5e 30             	lea    0x30(%esi),%ebx
801038d1:	8d 7e 70             	lea    0x70(%esi),%edi
    if (curproc->ofile[fd])
801038d4:	8b 03                	mov    (%ebx),%eax
801038d6:	85 c0                	test   %eax,%eax
801038d8:	74 12                	je     801038ec <exit+0x48>
      fileclose(curproc->ofile[fd]);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	50                   	push   %eax
801038de:	e8 b9 d4 ff ff       	call   80100d9c <fileclose>
      curproc->ofile[fd] = 0;
801038e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801038e9:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801038ec:	83 c3 04             	add    $0x4,%ebx
801038ef:	39 df                	cmp    %ebx,%edi
801038f1:	75 e1                	jne    801038d4 <exit+0x30>
  begin_op();
801038f3:	e8 44 ef ff ff       	call   8010283c <begin_op>
  iput(curproc->cwd);
801038f8:	83 ec 0c             	sub    $0xc,%esp
801038fb:	ff 76 70             	pushl  0x70(%esi)
801038fe:	e8 65 dd ff ff       	call   80101668 <iput>
  end_op();
80103903:	e8 9c ef ff ff       	call   801028a4 <end_op>
  curproc->cwd = 0;
80103908:	c7 46 70 00 00 00 00 	movl   $0x0,0x70(%esi)
  acquire(&ptable.lock);
8010390f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103916:	e8 61 07 00 00       	call   8010407c <acquire>
  wakeup1(curproc->parent);
8010391b:	8b 56 1c             	mov    0x1c(%esi),%edx
8010391e:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103921:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103926:	eb 0c                	jmp    80103934 <exit+0x90>
80103928:	05 84 00 00 00       	add    $0x84,%eax
8010392d:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103932:	74 1e                	je     80103952 <exit+0xae>
    if (p->state == SLEEPING && p->chan == chan)
80103934:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103938:	75 ee                	jne    80103928 <exit+0x84>
8010393a:	3b 50 28             	cmp    0x28(%eax),%edx
8010393d:	75 e9                	jne    80103928 <exit+0x84>
      p->state = RUNNABLE;
8010393f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103946:	05 84 00 00 00       	add    $0x84,%eax
8010394b:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103950:	75 e2                	jne    80103934 <exit+0x90>
      p->parent = initproc;
80103952:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103958:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010395d:	eb 0f                	jmp    8010396e <exit+0xca>
8010395f:	90                   	nop
80103960:	81 c2 84 00 00 00    	add    $0x84,%edx
80103966:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
8010396c:	74 36                	je     801039a4 <exit+0x100>
    if (p->parent == curproc)
8010396e:	39 72 1c             	cmp    %esi,0x1c(%edx)
80103971:	75 ed                	jne    80103960 <exit+0xbc>
      p->parent = initproc;
80103973:	89 4a 1c             	mov    %ecx,0x1c(%edx)
      if (p->state == ZOMBIE)
80103976:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
8010397a:	75 e4                	jne    80103960 <exit+0xbc>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010397c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103981:	eb 0d                	jmp    80103990 <exit+0xec>
80103983:	90                   	nop
80103984:	05 84 00 00 00       	add    $0x84,%eax
80103989:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
8010398e:	74 d0                	je     80103960 <exit+0xbc>
    if (p->state == SLEEPING && p->chan == chan)
80103990:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103994:	75 ee                	jne    80103984 <exit+0xe0>
80103996:	3b 48 28             	cmp    0x28(%eax),%ecx
80103999:	75 e9                	jne    80103984 <exit+0xe0>
      p->state = RUNNABLE;
8010399b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801039a2:	eb e0                	jmp    80103984 <exit+0xe0>
  curproc->state = ZOMBIE;
801039a4:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801039ab:	e8 40 fe ff ff       	call   801037f0 <sched>
  panic("zombie exit");
801039b0:	83 ec 0c             	sub    $0xc,%esp
801039b3:	68 08 6e 10 80       	push   $0x80106e08
801039b8:	e8 83 c9 ff ff       	call   80100340 <panic>
    panic("init exiting");
801039bd:	83 ec 0c             	sub    $0xc,%esp
801039c0:	68 fb 6d 10 80       	push   $0x80106dfb
801039c5:	e8 76 c9 ff ff       	call   80100340 <panic>
801039ca:	66 90                	xchg   %ax,%ax

801039cc <yield>:
{
801039cc:	55                   	push   %ebp
801039cd:	89 e5                	mov    %esp,%ebp
801039cf:	53                   	push   %ebx
801039d0:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
801039d3:	68 20 2d 11 80       	push   $0x80112d20
801039d8:	e8 9f 06 00 00       	call   8010407c <acquire>
  pushcli();
801039dd:	e8 be 05 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
801039e2:	e8 e5 f8 ff ff       	call   801032cc <mycpu>
  p = c->proc;
801039e7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039ed:	e8 f6 05 00 00       	call   80103fe8 <popcli>
  myproc()->state = RUNNABLE;
801039f2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801039f9:	e8 f2 fd ff ff       	call   801037f0 <sched>
  release(&ptable.lock);
801039fe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a05:	e8 0a 07 00 00       	call   80104114 <release>
}
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a10:	c9                   	leave  
80103a11:	c3                   	ret    
80103a12:	66 90                	xchg   %ax,%ax

80103a14 <sleep>:
{
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	57                   	push   %edi
80103a18:	56                   	push   %esi
80103a19:	53                   	push   %ebx
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103a20:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103a23:	e8 78 05 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
80103a28:	e8 9f f8 ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103a2d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a33:	e8 b0 05 00 00       	call   80103fe8 <popcli>
  if (p == 0)
80103a38:	85 db                	test   %ebx,%ebx
80103a3a:	0f 84 83 00 00 00    	je     80103ac3 <sleep+0xaf>
  if (lk == 0)
80103a40:	85 f6                	test   %esi,%esi
80103a42:	74 72                	je     80103ab6 <sleep+0xa2>
  if (lk != &ptable.lock)
80103a44:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103a4a:	74 4c                	je     80103a98 <sleep+0x84>
    acquire(&ptable.lock); // DOC: sleeplock1
80103a4c:	83 ec 0c             	sub    $0xc,%esp
80103a4f:	68 20 2d 11 80       	push   $0x80112d20
80103a54:	e8 23 06 00 00       	call   8010407c <acquire>
    release(lk);
80103a59:	89 34 24             	mov    %esi,(%esp)
80103a5c:	e8 b3 06 00 00       	call   80104114 <release>
  p->chan = chan;
80103a61:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103a64:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a6b:	e8 80 fd ff ff       	call   801037f0 <sched>
  p->chan = 0;
80103a70:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    release(&ptable.lock);
80103a77:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a7e:	e8 91 06 00 00       	call   80104114 <release>
    acquire(lk);
80103a83:	83 c4 10             	add    $0x10,%esp
80103a86:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a8c:	5b                   	pop    %ebx
80103a8d:	5e                   	pop    %esi
80103a8e:	5f                   	pop    %edi
80103a8f:	5d                   	pop    %ebp
    acquire(lk);
80103a90:	e9 e7 05 00 00       	jmp    8010407c <acquire>
80103a95:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103a98:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103a9b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103aa2:	e8 49 fd ff ff       	call   801037f0 <sched>
  p->chan = 0;
80103aa7:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
80103aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ab1:	5b                   	pop    %ebx
80103ab2:	5e                   	pop    %esi
80103ab3:	5f                   	pop    %edi
80103ab4:	5d                   	pop    %ebp
80103ab5:	c3                   	ret    
    panic("sleep without lk");
80103ab6:	83 ec 0c             	sub    $0xc,%esp
80103ab9:	68 1a 6e 10 80       	push   $0x80106e1a
80103abe:	e8 7d c8 ff ff       	call   80100340 <panic>
    panic("sleep");
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	68 14 6e 10 80       	push   $0x80106e14
80103acb:	e8 70 c8 ff ff       	call   80100340 <panic>

80103ad0 <wait>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80103ad8:	e8 c3 04 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
80103add:	e8 ea f7 ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103ae2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ae8:	e8 fb 04 00 00       	call   80103fe8 <popcli>
  acquire(&ptable.lock);
80103aed:	83 ec 0c             	sub    $0xc,%esp
80103af0:	68 20 2d 11 80       	push   $0x80112d20
80103af5:	e8 82 05 00 00       	call   8010407c <acquire>
80103afa:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103afd:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103aff:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103b04:	eb 10                	jmp    80103b16 <wait+0x46>
80103b06:	66 90                	xchg   %ax,%ax
80103b08:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103b0e:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103b14:	74 1e                	je     80103b34 <wait+0x64>
      if (p->parent != curproc)
80103b16:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80103b19:	75 ed                	jne    80103b08 <wait+0x38>
      if (p->state == ZOMBIE)
80103b1b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103b1f:	74 33                	je     80103b54 <wait+0x84>
      havekids = 1;
80103b21:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b26:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103b2c:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103b32:	75 e2                	jne    80103b16 <wait+0x46>
    if (!havekids || curproc->killed)
80103b34:	85 c0                	test   %eax,%eax
80103b36:	74 76                	je     80103bae <wait+0xde>
80103b38:	8b 46 2c             	mov    0x2c(%esi),%eax
80103b3b:	85 c0                	test   %eax,%eax
80103b3d:	75 6f                	jne    80103bae <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80103b3f:	83 ec 08             	sub    $0x8,%esp
80103b42:	68 20 2d 11 80       	push   $0x80112d20
80103b47:	56                   	push   %esi
80103b48:	e8 c7 fe ff ff       	call   80103a14 <sleep>
    havekids = 0;
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	eb ab                	jmp    80103afd <wait+0x2d>
80103b52:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80103b54:	8b 43 18             	mov    0x18(%ebx),%eax
80103b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	ff 73 08             	pushl  0x8(%ebx)
80103b60:	e8 3f e5 ff ff       	call   801020a4 <kfree>
        p->kstack = 0;
80103b65:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103b6c:	5a                   	pop    %edx
80103b6d:	ff 73 04             	pushl  0x4(%ebx)
80103b70:	e8 eb 29 00 00       	call   80106560 <freevm>
        p->pid = 0;
80103b75:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->parent = 0;
80103b7c:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
80103b83:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
80103b87:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80103b8e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103b95:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b9c:	e8 73 05 00 00       	call   80104114 <release>
        return pid;
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103ba7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103baa:	5b                   	pop    %ebx
80103bab:	5e                   	pop    %esi
80103bac:	5d                   	pop    %ebp
80103bad:	c3                   	ret    
      release(&ptable.lock);
80103bae:	83 ec 0c             	sub    $0xc,%esp
80103bb1:	68 20 2d 11 80       	push   $0x80112d20
80103bb6:	e8 59 05 00 00       	call   80104114 <release>
      return -1;
80103bbb:	83 c4 10             	add    $0x10,%esp
80103bbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bc3:	eb e2                	jmp    80103ba7 <wait+0xd7>
80103bc5:	8d 76 00             	lea    0x0(%esi),%esi

80103bc8 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80103bc8:	55                   	push   %ebp
80103bc9:	89 e5                	mov    %esp,%ebp
80103bcb:	53                   	push   %ebx
80103bcc:	83 ec 10             	sub    $0x10,%esp
80103bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103bd2:	68 20 2d 11 80       	push   $0x80112d20
80103bd7:	e8 a0 04 00 00       	call   8010407c <acquire>
80103bdc:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bdf:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103be4:	eb 0e                	jmp    80103bf4 <wakeup+0x2c>
80103be6:	66 90                	xchg   %ax,%ax
80103be8:	05 84 00 00 00       	add    $0x84,%eax
80103bed:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103bf2:	74 1e                	je     80103c12 <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80103bf4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103bf8:	75 ee                	jne    80103be8 <wakeup+0x20>
80103bfa:	3b 58 28             	cmp    0x28(%eax),%ebx
80103bfd:	75 e9                	jne    80103be8 <wakeup+0x20>
      p->state = RUNNABLE;
80103bff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c06:	05 84 00 00 00       	add    $0x84,%eax
80103c0b:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103c10:	75 e2                	jne    80103bf4 <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103c12:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1c:	c9                   	leave  
  release(&ptable.lock);
80103c1d:	e9 f2 04 00 00       	jmp    80104114 <release>
80103c22:	66 90                	xchg   %ax,%ax

80103c24 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	53                   	push   %ebx
80103c28:	83 ec 10             	sub    $0x10,%esp
80103c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103c2e:	68 20 2d 11 80       	push   $0x80112d20
80103c33:	e8 44 04 00 00       	call   8010407c <acquire>
80103c38:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c3b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c40:	eb 0e                	jmp    80103c50 <kill+0x2c>
80103c42:	66 90                	xchg   %ax,%ax
80103c44:	05 84 00 00 00       	add    $0x84,%eax
80103c49:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103c4e:	74 30                	je     80103c80 <kill+0x5c>
  {
    if (p->pid == pid)
80103c50:	39 58 18             	cmp    %ebx,0x18(%eax)
80103c53:	75 ef                	jne    80103c44 <kill+0x20>
    {
      p->killed = 1;
80103c55:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80103c5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c60:	75 07                	jne    80103c69 <kill+0x45>
        p->state = RUNNABLE;
80103c62:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103c69:	83 ec 0c             	sub    $0xc,%esp
80103c6c:	68 20 2d 11 80       	push   $0x80112d20
80103c71:	e8 9e 04 00 00       	call   80104114 <release>
      return 0;
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7e:	c9                   	leave  
80103c7f:	c3                   	ret    
  release(&ptable.lock);
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 20 2d 11 80       	push   $0x80112d20
80103c88:	e8 87 04 00 00       	call   80104114 <release>
  return -1;
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c98:	c9                   	leave  
80103c99:	c3                   	ret    
80103c9a:	66 90                	xchg   %ax,%ax

80103c9c <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80103c9c:	55                   	push   %ebp
80103c9d:	89 e5                	mov    %esp,%ebp
80103c9f:	57                   	push   %edi
80103ca0:	56                   	push   %esi
80103ca1:	53                   	push   %ebx
80103ca2:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca5:	bb c8 2d 11 80       	mov    $0x80112dc8,%ebx
80103caa:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103cad:	eb 42                	jmp    80103cf1 <procdump+0x55>
80103caf:	90                   	nop
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103cb0:	8b 04 85 c8 6e 10 80 	mov    -0x7fef9138(,%eax,4),%eax
80103cb7:	85 c0                	test   %eax,%eax
80103cb9:	74 42                	je     80103cfd <procdump+0x61>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103cbb:	53                   	push   %ebx
80103cbc:	50                   	push   %eax
80103cbd:	ff 73 a4             	pushl  -0x5c(%ebx)
80103cc0:	68 2f 6e 10 80       	push   $0x80106e2f
80103cc5:	e8 56 c9 ff ff       	call   80100620 <cprintf>
    if (p->state == SLEEPING)
80103cca:	83 c4 10             	add    $0x10,%esp
80103ccd:	83 7b 98 02          	cmpl   $0x2,-0x68(%ebx)
80103cd1:	74 31                	je     80103d04 <procdump+0x68>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103cd3:	83 ec 0c             	sub    $0xc,%esp
80103cd6:	68 df 71 10 80       	push   $0x801071df
80103cdb:	e8 40 c9 ff ff       	call   80100620 <cprintf>
80103ce0:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce3:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103ce9:	81 fb c8 4e 11 80    	cmp    $0x80114ec8,%ebx
80103cef:	74 4f                	je     80103d40 <procdump+0xa4>
    if (p->state == UNUSED)
80103cf1:	8b 43 98             	mov    -0x68(%ebx),%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 eb                	je     80103ce3 <procdump+0x47>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103cf8:	83 f8 05             	cmp    $0x5,%eax
80103cfb:	76 b3                	jbe    80103cb0 <procdump+0x14>
      state = "???";
80103cfd:	b8 2b 6e 10 80       	mov    $0x80106e2b,%eax
80103d02:	eb b7                	jmp    80103cbb <procdump+0x1f>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80103d04:	83 ec 08             	sub    $0x8,%esp
80103d07:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103d0a:	50                   	push   %eax
80103d0b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103d0e:	8b 40 0c             	mov    0xc(%eax),%eax
80103d11:	83 c0 08             	add    $0x8,%eax
80103d14:	50                   	push   %eax
80103d15:	e8 3e 02 00 00       	call   80103f58 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103d1a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	8b 17                	mov    (%edi),%edx
80103d22:	85 d2                	test   %edx,%edx
80103d24:	74 ad                	je     80103cd3 <procdump+0x37>
        cprintf(" %p", pc[i]);
80103d26:	83 ec 08             	sub    $0x8,%esp
80103d29:	52                   	push   %edx
80103d2a:	68 81 68 10 80       	push   $0x80106881
80103d2f:	e8 ec c8 ff ff       	call   80100620 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80103d34:	83 c7 04             	add    $0x4,%edi
80103d37:	83 c4 10             	add    $0x10,%esp
80103d3a:	39 fe                	cmp    %edi,%esi
80103d3c:	75 e2                	jne    80103d20 <procdump+0x84>
80103d3e:	eb 93                	jmp    80103cd3 <procdump+0x37>
  }
}
80103d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d43:	5b                   	pop    %ebx
80103d44:	5e                   	pop    %esi
80103d45:	5f                   	pop    %edi
80103d46:	5d                   	pop    %ebp
80103d47:	c3                   	ret    

80103d48 <settickets>:

int settickets(int tickets)
{
80103d48:	55                   	push   %ebp
80103d49:	89 e5                	mov    %esp,%ebp
80103d4b:	53                   	push   %ebx
80103d4c:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  acquire(&ptable.lock);
80103d4f:	68 20 2d 11 80       	push   $0x80112d20
80103d54:	e8 23 03 00 00       	call   8010407c <acquire>
  pushcli();
80103d59:	e8 42 02 00 00       	call   80103fa0 <pushcli>
  c = mycpu();
80103d5e:	e8 69 f5 ff ff       	call   801032cc <mycpu>
  p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d69:	e8 7a 02 00 00       	call   80103fe8 <popcli>

  int mypid = myproc()->pid;
80103d6e:	8b 53 18             	mov    0x18(%ebx),%edx
80103d71:	83 c4 10             	add    $0x10,%esp

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d74:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d79:	eb 0d                	jmp    80103d88 <settickets+0x40>
80103d7b:	90                   	nop
80103d7c:	05 84 00 00 00       	add    $0x84,%eax
80103d81:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103d86:	74 24                	je     80103dac <settickets+0x64>
  {
    if (p->pid == mypid)
80103d88:	39 50 18             	cmp    %edx,0x18(%eax)
80103d8b:	75 ef                	jne    80103d7c <settickets+0x34>
    {
      p->tickets = tickets;
80103d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80103d90:	89 50 10             	mov    %edx,0x10(%eax)
      release(&ptable.lock);
80103d93:	83 ec 0c             	sub    $0xc,%esp
80103d96:	68 20 2d 11 80       	push   $0x80112d20
80103d9b:	e8 74 03 00 00       	call   80104114 <release>
      return 0;
80103da0:	83 c4 10             	add    $0x10,%esp
80103da3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da8:	c9                   	leave  
80103da9:	c3                   	ret    
80103daa:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103dac:	83 ec 0c             	sub    $0xc,%esp
80103daf:	68 20 2d 11 80       	push   $0x80112d20
80103db4:	e8 5b 03 00 00       	call   80104114 <release>
  return -1;
80103db9:	83 c4 10             	add    $0x10,%esp
80103dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    
80103dc6:	66 90                	xchg   %ax,%ax

80103dc8 <getpinfo>:

int getpinfo(struct pstat *p)
{
80103dc8:	55                   	push   %ebp
80103dc9:	89 e5                	mov    %esp,%ebp
80103dcb:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103dce:	68 20 2d 11 80       	push   $0x80112d20
80103dd3:	e8 a4 02 00 00       	call   8010407c <acquire>
  for (int i = 0; i < NPROC; i++)
80103dd8:	b8 60 2d 11 80       	mov    $0x80112d60,%eax
80103ddd:	8b 55 08             	mov    0x8(%ebp),%edx
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	90                   	nop
  {
    p->inuse[i] = ptable.proc[i].state == UNUSED ? 0 : 1;
80103de4:	31 c9                	xor    %ecx,%ecx
80103de6:	83 38 00             	cmpl   $0x0,(%eax)
80103de9:	0f 95 c1             	setne  %cl
80103dec:	89 0a                	mov    %ecx,(%edx)
    p->tickets[i] = ptable.proc[i].tickets;
80103dee:	8b 48 04             	mov    0x4(%eax),%ecx
80103df1:	89 8a 00 01 00 00    	mov    %ecx,0x100(%edx)
    p->pid[i] = ptable.proc[i].pid;
80103df7:	8b 48 0c             	mov    0xc(%eax),%ecx
80103dfa:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
    p->ticks[i] = ptable.proc[i].ticks;
80103e00:	8b 48 08             	mov    0x8(%eax),%ecx
80103e03:	89 8a 00 03 00 00    	mov    %ecx,0x300(%edx)
  for (int i = 0; i < NPROC; i++)
80103e09:	05 84 00 00 00       	add    $0x84,%eax
80103e0e:	83 c2 04             	add    $0x4,%edx
80103e11:	3d 60 4e 11 80       	cmp    $0x80114e60,%eax
80103e16:	75 cc                	jne    80103de4 <getpinfo+0x1c>
  }
  release(&ptable.lock);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	68 20 2d 11 80       	push   $0x80112d20
80103e20:	e8 ef 02 00 00       	call   80104114 <release>
  return 0;
}
80103e25:	31 c0                	xor    %eax,%eax
80103e27:	c9                   	leave  
80103e28:	c3                   	ret    
80103e29:	66 90                	xchg   %ax,%ax
80103e2b:	90                   	nop

80103e2c <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103e2c:	55                   	push   %ebp
80103e2d:	89 e5                	mov    %esp,%ebp
80103e2f:	53                   	push   %ebx
80103e30:	83 ec 0c             	sub    $0xc,%esp
80103e33:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103e36:	68 e0 6e 10 80       	push   $0x80106ee0
80103e3b:	8d 43 04             	lea    0x4(%ebx),%eax
80103e3e:	50                   	push   %eax
80103e3f:	e8 f8 00 00 00       	call   80103f3c <initlock>
  lk->name = name;
80103e44:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e47:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103e4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103e50:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e5d:	c9                   	leave  
80103e5e:	c3                   	ret    
80103e5f:	90                   	nop

80103e60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
80103e65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103e68:	8d 73 04             	lea    0x4(%ebx),%esi
80103e6b:	83 ec 0c             	sub    $0xc,%esp
80103e6e:	56                   	push   %esi
80103e6f:	e8 08 02 00 00       	call   8010407c <acquire>
  while (lk->locked) {
80103e74:	83 c4 10             	add    $0x10,%esp
80103e77:	8b 13                	mov    (%ebx),%edx
80103e79:	85 d2                	test   %edx,%edx
80103e7b:	74 16                	je     80103e93 <acquiresleep+0x33>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103e80:	83 ec 08             	sub    $0x8,%esp
80103e83:	56                   	push   %esi
80103e84:	53                   	push   %ebx
80103e85:	e8 8a fb ff ff       	call   80103a14 <sleep>
  while (lk->locked) {
80103e8a:	83 c4 10             	add    $0x10,%esp
80103e8d:	8b 03                	mov    (%ebx),%eax
80103e8f:	85 c0                	test   %eax,%eax
80103e91:	75 ed                	jne    80103e80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103e93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103e99:	e8 c6 f4 ff ff       	call   80103364 <myproc>
80103e9e:	8b 40 18             	mov    0x18(%eax),%eax
80103ea1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103ea4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ea7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eaa:	5b                   	pop    %ebx
80103eab:	5e                   	pop    %esi
80103eac:	5d                   	pop    %ebp
  release(&lk->lk);
80103ead:	e9 62 02 00 00       	jmp    80104114 <release>
80103eb2:	66 90                	xchg   %ax,%ax

80103eb4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	56                   	push   %esi
80103eb8:	53                   	push   %ebx
80103eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ebc:	8d 73 04             	lea    0x4(%ebx),%esi
80103ebf:	83 ec 0c             	sub    $0xc,%esp
80103ec2:	56                   	push   %esi
80103ec3:	e8 b4 01 00 00       	call   8010407c <acquire>
  lk->locked = 0;
80103ec8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ece:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103ed5:	89 1c 24             	mov    %ebx,(%esp)
80103ed8:	e8 eb fc ff ff       	call   80103bc8 <wakeup>
  release(&lk->lk);
80103edd:	83 c4 10             	add    $0x10,%esp
80103ee0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ee6:	5b                   	pop    %ebx
80103ee7:	5e                   	pop    %esi
80103ee8:	5d                   	pop    %ebp
  release(&lk->lk);
80103ee9:	e9 26 02 00 00       	jmp    80104114 <release>
80103eee:	66 90                	xchg   %ax,%ax

80103ef0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	83 ec 1c             	sub    $0x1c,%esp
80103ef8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103efb:	8d 73 04             	lea    0x4(%ebx),%esi
80103efe:	56                   	push   %esi
80103eff:	e8 78 01 00 00       	call   8010407c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103f04:	83 c4 10             	add    $0x10,%esp
80103f07:	8b 03                	mov    (%ebx),%eax
80103f09:	85 c0                	test   %eax,%eax
80103f0b:	75 1b                	jne    80103f28 <holdingsleep+0x38>
80103f0d:	31 c0                	xor    %eax,%eax
80103f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80103f12:	83 ec 0c             	sub    $0xc,%esp
80103f15:	56                   	push   %esi
80103f16:	e8 f9 01 00 00       	call   80104114 <release>
  return r;
}
80103f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5d                   	pop    %ebp
80103f24:	c3                   	ret    
80103f25:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80103f28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103f2b:	e8 34 f4 ff ff       	call   80103364 <myproc>
80103f30:	39 58 18             	cmp    %ebx,0x18(%eax)
80103f33:	0f 94 c0             	sete   %al
80103f36:	0f b6 c0             	movzbl %al,%eax
80103f39:	eb d4                	jmp    80103f0f <holdingsleep+0x1f>
80103f3b:	90                   	nop

80103f3c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103f3c:	55                   	push   %ebp
80103f3d:	89 e5                	mov    %esp,%ebp
80103f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103f42:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f45:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103f4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103f55:	5d                   	pop    %ebp
80103f56:	c3                   	ret    
80103f57:	90                   	nop

80103f58 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103f58:	55                   	push   %ebp
80103f59:	89 e5                	mov    %esp,%ebp
80103f5b:	53                   	push   %ebx
80103f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f62:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80103f65:	31 d2                	xor    %edx,%edx
80103f67:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103f68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80103f6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103f74:	77 12                	ja     80103f88 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103f76:	8b 58 04             	mov    0x4(%eax),%ebx
80103f79:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103f7c:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80103f7e:	42                   	inc    %edx
80103f7f:	83 fa 0a             	cmp    $0xa,%edx
80103f82:	75 e4                	jne    80103f68 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103f84:	5b                   	pop    %ebx
80103f85:	5d                   	pop    %ebp
80103f86:	c3                   	ret    
80103f87:	90                   	nop
  for(; i < 10; i++)
80103f88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80103f8b:	8d 51 28             	lea    0x28(%ecx),%edx
80103f8e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80103f90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80103f96:	83 c0 04             	add    $0x4,%eax
80103f99:	39 d0                	cmp    %edx,%eax
80103f9b:	75 f3                	jne    80103f90 <getcallerpcs+0x38>
}
80103f9d:	5b                   	pop    %ebx
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    

80103fa0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	52                   	push   %edx
80103fa5:	9c                   	pushf  
80103fa6:	5b                   	pop    %ebx
  asm volatile("cli");
80103fa7:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103fa8:	e8 1f f3 ff ff       	call   801032cc <mycpu>
80103fad:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103fb3:	85 c9                	test   %ecx,%ecx
80103fb5:	74 11                	je     80103fc8 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103fb7:	e8 10 f3 ff ff       	call   801032cc <mycpu>
80103fbc:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103fc2:	58                   	pop    %eax
80103fc3:	5b                   	pop    %ebx
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
80103fc6:	66 90                	xchg   %ax,%ax
    mycpu()->intena = eflags & FL_IF;
80103fc8:	e8 ff f2 ff ff       	call   801032cc <mycpu>
80103fcd:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103fd3:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80103fd9:	e8 ee f2 ff ff       	call   801032cc <mycpu>
80103fde:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103fe4:	58                   	pop    %eax
80103fe5:	5b                   	pop    %ebx
80103fe6:	5d                   	pop    %ebp
80103fe7:	c3                   	ret    

80103fe8 <popcli>:

void
popcli(void)
{
80103fe8:	55                   	push   %ebp
80103fe9:	89 e5                	mov    %esp,%ebp
80103feb:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fee:	9c                   	pushf  
80103fef:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ff0:	f6 c4 02             	test   $0x2,%ah
80103ff3:	75 31                	jne    80104026 <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103ff5:	e8 d2 f2 ff ff       	call   801032cc <mycpu>
80103ffa:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80104000:	78 31                	js     80104033 <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104002:	e8 c5 f2 ff ff       	call   801032cc <mycpu>
80104007:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010400d:	85 d2                	test   %edx,%edx
8010400f:	74 03                	je     80104014 <popcli+0x2c>
    sti();
}
80104011:	c9                   	leave  
80104012:	c3                   	ret    
80104013:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104014:	e8 b3 f2 ff ff       	call   801032cc <mycpu>
80104019:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010401f:	85 c0                	test   %eax,%eax
80104021:	74 ee                	je     80104011 <popcli+0x29>
  asm volatile("sti");
80104023:	fb                   	sti    
}
80104024:	c9                   	leave  
80104025:	c3                   	ret    
    panic("popcli - interruptible");
80104026:	83 ec 0c             	sub    $0xc,%esp
80104029:	68 eb 6e 10 80       	push   $0x80106eeb
8010402e:	e8 0d c3 ff ff       	call   80100340 <panic>
    panic("popcli");
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 02 6f 10 80       	push   $0x80106f02
8010403b:	e8 00 c3 ff ff       	call   80100340 <panic>

80104040 <holding>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 14             	sub    $0x14,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010404a:	e8 51 ff ff ff       	call   80103fa0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010404f:	8b 03                	mov    (%ebx),%eax
80104051:	85 c0                	test   %eax,%eax
80104053:	75 13                	jne    80104068 <holding+0x28>
80104055:	31 c0                	xor    %eax,%eax
80104057:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
8010405a:	e8 89 ff ff ff       	call   80103fe8 <popcli>
}
8010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104062:	83 c4 14             	add    $0x14,%esp
80104065:	5b                   	pop    %ebx
80104066:	5d                   	pop    %ebp
80104067:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104068:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010406b:	e8 5c f2 ff ff       	call   801032cc <mycpu>
80104070:	39 c3                	cmp    %eax,%ebx
80104072:	0f 94 c0             	sete   %al
80104075:	0f b6 c0             	movzbl %al,%eax
80104078:	eb dd                	jmp    80104057 <holding+0x17>
8010407a:	66 90                	xchg   %ax,%ax

8010407c <acquire>:
{
8010407c:	55                   	push   %ebp
8010407d:	89 e5                	mov    %esp,%ebp
8010407f:	56                   	push   %esi
80104080:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104081:	e8 1a ff ff ff       	call   80103fa0 <pushcli>
  if(holding(lk))
80104086:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104089:	83 ec 0c             	sub    $0xc,%esp
8010408c:	53                   	push   %ebx
8010408d:	e8 ae ff ff ff       	call   80104040 <holding>
80104092:	83 c4 10             	add    $0x10,%esp
80104095:	85 c0                	test   %eax,%eax
80104097:	75 6b                	jne    80104104 <acquire+0x88>
80104099:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
8010409b:	ba 01 00 00 00       	mov    $0x1,%edx
801040a0:	eb 05                	jmp    801040a7 <acquire+0x2b>
801040a2:	66 90                	xchg   %ax,%ax
801040a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040a7:	89 d0                	mov    %edx,%eax
801040a9:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801040ac:	85 c0                	test   %eax,%eax
801040ae:	75 f4                	jne    801040a4 <acquire+0x28>
  __sync_synchronize();
801040b0:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801040b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040b8:	e8 0f f2 ff ff       	call   801032cc <mycpu>
801040bd:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801040c0:	89 e8                	mov    %ebp,%eax
801040c2:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040c4:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801040ca:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801040d0:	77 16                	ja     801040e8 <acquire+0x6c>
    pcs[i] = ebp[1];     // saved %eip
801040d2:	8b 50 04             	mov    0x4(%eax),%edx
801040d5:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
    ebp = (uint*)ebp[0]; // saved %ebp
801040d9:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801040db:	46                   	inc    %esi
801040dc:	83 fe 0a             	cmp    $0xa,%esi
801040df:	75 e3                	jne    801040c4 <acquire+0x48>
}
801040e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040e4:	5b                   	pop    %ebx
801040e5:	5e                   	pop    %esi
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
  for(; i < 10; i++)
801040e8:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801040ec:	83 c3 34             	add    $0x34,%ebx
801040ef:	90                   	nop
    pcs[i] = 0;
801040f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801040f6:	83 c0 04             	add    $0x4,%eax
801040f9:	39 d8                	cmp    %ebx,%eax
801040fb:	75 f3                	jne    801040f0 <acquire+0x74>
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	5b                   	pop    %ebx
80104101:	5e                   	pop    %esi
80104102:	5d                   	pop    %ebp
80104103:	c3                   	ret    
    panic("acquire");
80104104:	83 ec 0c             	sub    $0xc,%esp
80104107:	68 09 6f 10 80       	push   $0x80106f09
8010410c:	e8 2f c2 ff ff       	call   80100340 <panic>
80104111:	8d 76 00             	lea    0x0(%esi),%esi

80104114 <release>:
{
80104114:	55                   	push   %ebp
80104115:	89 e5                	mov    %esp,%ebp
80104117:	53                   	push   %ebx
80104118:	83 ec 10             	sub    $0x10,%esp
8010411b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010411e:	53                   	push   %ebx
8010411f:	e8 1c ff ff ff       	call   80104040 <holding>
80104124:	83 c4 10             	add    $0x10,%esp
80104127:	85 c0                	test   %eax,%eax
80104129:	74 22                	je     8010414d <release+0x39>
  lk->pcs[0] = 0;
8010412b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104132:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104139:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010413e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104147:	c9                   	leave  
  popcli();
80104148:	e9 9b fe ff ff       	jmp    80103fe8 <popcli>
    panic("release");
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	68 11 6f 10 80       	push   $0x80106f11
80104155:	e8 e6 c1 ff ff       	call   80100340 <panic>
8010415a:	66 90                	xchg   %ax,%ax

8010415c <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010415c:	55                   	push   %ebp
8010415d:	89 e5                	mov    %esp,%ebp
8010415f:	57                   	push   %edi
80104160:	53                   	push   %ebx
80104161:	8b 55 08             	mov    0x8(%ebp),%edx
80104164:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104167:	89 d0                	mov    %edx,%eax
80104169:	09 c8                	or     %ecx,%eax
8010416b:	a8 03                	test   $0x3,%al
8010416d:	75 29                	jne    80104198 <memset+0x3c>
    c &= 0xFF;
8010416f:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104173:	c1 e9 02             	shr    $0x2,%ecx
80104176:	8b 45 0c             	mov    0xc(%ebp),%eax
80104179:	c1 e0 18             	shl    $0x18,%eax
8010417c:	89 fb                	mov    %edi,%ebx
8010417e:	c1 e3 10             	shl    $0x10,%ebx
80104181:	09 d8                	or     %ebx,%eax
80104183:	09 f8                	or     %edi,%eax
80104185:	c1 e7 08             	shl    $0x8,%edi
80104188:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010418a:	89 d7                	mov    %edx,%edi
8010418c:	fc                   	cld    
8010418d:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
8010418f:	89 d0                	mov    %edx,%eax
80104191:	5b                   	pop    %ebx
80104192:	5f                   	pop    %edi
80104193:	5d                   	pop    %ebp
80104194:	c3                   	ret    
80104195:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104198:	89 d7                	mov    %edx,%edi
8010419a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010419d:	fc                   	cld    
8010419e:	f3 aa                	rep stos %al,%es:(%edi)
801041a0:	89 d0                	mov    %edx,%eax
801041a2:	5b                   	pop    %ebx
801041a3:	5f                   	pop    %edi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    
801041a6:	66 90                	xchg   %ax,%ax

801041a8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801041a8:	55                   	push   %ebp
801041a9:	89 e5                	mov    %esp,%ebp
801041ab:	56                   	push   %esi
801041ac:	53                   	push   %ebx
801041ad:	8b 55 08             	mov    0x8(%ebp),%edx
801041b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b3:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801041b6:	85 f6                	test   %esi,%esi
801041b8:	74 1e                	je     801041d8 <memcmp+0x30>
801041ba:	01 c6                	add    %eax,%esi
801041bc:	eb 08                	jmp    801041c6 <memcmp+0x1e>
801041be:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801041c0:	42                   	inc    %edx
801041c1:	40                   	inc    %eax
  while(n-- > 0){
801041c2:	39 f0                	cmp    %esi,%eax
801041c4:	74 12                	je     801041d8 <memcmp+0x30>
    if(*s1 != *s2)
801041c6:	8a 0a                	mov    (%edx),%cl
801041c8:	0f b6 18             	movzbl (%eax),%ebx
801041cb:	38 d9                	cmp    %bl,%cl
801041cd:	74 f1                	je     801041c0 <memcmp+0x18>
      return *s1 - *s2;
801041cf:	0f b6 c1             	movzbl %cl,%eax
801041d2:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801041d4:	5b                   	pop    %ebx
801041d5:	5e                   	pop    %esi
801041d6:	5d                   	pop    %ebp
801041d7:	c3                   	ret    
  return 0;
801041d8:	31 c0                	xor    %eax,%eax
}
801041da:	5b                   	pop    %ebx
801041db:	5e                   	pop    %esi
801041dc:	5d                   	pop    %ebp
801041dd:	c3                   	ret    
801041de:	66 90                	xchg   %ax,%ax

801041e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	8b 55 08             	mov    0x8(%ebp),%edx
801041e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801041eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801041ee:	39 d6                	cmp    %edx,%esi
801041f0:	73 07                	jae    801041f9 <memmove+0x19>
801041f2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801041f5:	39 fa                	cmp    %edi,%edx
801041f7:	72 17                	jb     80104210 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801041f9:	85 c9                	test   %ecx,%ecx
801041fb:	74 0c                	je     80104209 <memmove+0x29>
801041fd:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104200:	89 d7                	mov    %edx,%edi
80104202:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104204:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104205:	39 f0                	cmp    %esi,%eax
80104207:	75 fb                	jne    80104204 <memmove+0x24>

  return dst;
}
80104209:	89 d0                	mov    %edx,%eax
8010420b:	5e                   	pop    %esi
8010420c:	5f                   	pop    %edi
8010420d:	5d                   	pop    %ebp
8010420e:	c3                   	ret    
8010420f:	90                   	nop
80104210:	8d 41 ff             	lea    -0x1(%ecx),%eax
    while(n-- > 0)
80104213:	85 c9                	test   %ecx,%ecx
80104215:	74 f2                	je     80104209 <memmove+0x29>
80104217:	90                   	nop
      *--d = *--s;
80104218:	8a 0c 06             	mov    (%esi,%eax,1),%cl
8010421b:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010421e:	48                   	dec    %eax
8010421f:	83 f8 ff             	cmp    $0xffffffff,%eax
80104222:	75 f4                	jne    80104218 <memmove+0x38>
}
80104224:	89 d0                	mov    %edx,%eax
80104226:	5e                   	pop    %esi
80104227:	5f                   	pop    %edi
80104228:	5d                   	pop    %ebp
80104229:	c3                   	ret    
8010422a:	66 90                	xchg   %ax,%ax

8010422c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
8010422c:	eb b2                	jmp    801041e0 <memmove>
8010422e:	66 90                	xchg   %ax,%ax

80104230 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
80104235:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104238:	8b 45 0c             	mov    0xc(%ebp),%eax
8010423b:	8b 75 10             	mov    0x10(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010423e:	85 f6                	test   %esi,%esi
80104240:	74 22                	je     80104264 <strncmp+0x34>
80104242:	01 c6                	add    %eax,%esi
80104244:	eb 0c                	jmp    80104252 <strncmp+0x22>
80104246:	66 90                	xchg   %ax,%ax
80104248:	38 ca                	cmp    %cl,%dl
8010424a:	75 0f                	jne    8010425b <strncmp+0x2b>
    n--, p++, q++;
8010424c:	43                   	inc    %ebx
8010424d:	40                   	inc    %eax
  while(n > 0 && *p && *p == *q)
8010424e:	39 f0                	cmp    %esi,%eax
80104250:	74 12                	je     80104264 <strncmp+0x34>
80104252:	8a 13                	mov    (%ebx),%dl
80104254:	0f b6 08             	movzbl (%eax),%ecx
80104257:	84 d2                	test   %dl,%dl
80104259:	75 ed                	jne    80104248 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010425b:	0f b6 c2             	movzbl %dl,%eax
8010425e:	29 c8                	sub    %ecx,%eax
}
80104260:	5b                   	pop    %ebx
80104261:	5e                   	pop    %esi
80104262:	5d                   	pop    %ebp
80104263:	c3                   	ret    
    return 0;
80104264:	31 c0                	xor    %eax,%eax
}
80104266:	5b                   	pop    %ebx
80104267:	5e                   	pop    %esi
80104268:	5d                   	pop    %ebp
80104269:	c3                   	ret    
8010426a:	66 90                	xchg   %ax,%ax

8010426c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010426c:	55                   	push   %ebp
8010426d:	89 e5                	mov    %esp,%ebp
8010426f:	56                   	push   %esi
80104270:	53                   	push   %ebx
80104271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104274:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104277:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010427a:	eb 0c                	jmp    80104288 <strncpy+0x1c>
8010427c:	43                   	inc    %ebx
8010427d:	41                   	inc    %ecx
8010427e:	8a 43 ff             	mov    -0x1(%ebx),%al
80104281:	88 41 ff             	mov    %al,-0x1(%ecx)
80104284:	84 c0                	test   %al,%al
80104286:	74 07                	je     8010428f <strncpy+0x23>
80104288:	89 d6                	mov    %edx,%esi
8010428a:	4a                   	dec    %edx
8010428b:	85 f6                	test   %esi,%esi
8010428d:	7f ed                	jg     8010427c <strncpy+0x10>
    ;
  while(n-- > 0)
8010428f:	89 cb                	mov    %ecx,%ebx
80104291:	85 d2                	test   %edx,%edx
80104293:	7e 14                	jle    801042a9 <strncpy+0x3d>
80104295:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104298:	43                   	inc    %ebx
80104299:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
  while(n-- > 0)
8010429d:	89 da                	mov    %ebx,%edx
8010429f:	f7 d2                	not    %edx
801042a1:	01 ca                	add    %ecx,%edx
801042a3:	01 f2                	add    %esi,%edx
801042a5:	85 d2                	test   %edx,%edx
801042a7:	7f ef                	jg     80104298 <strncpy+0x2c>
  return os;
}
801042a9:	8b 45 08             	mov    0x8(%ebp),%eax
801042ac:	5b                   	pop    %ebx
801042ad:	5e                   	pop    %esi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret    

801042b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	8b 45 08             	mov    0x8(%ebp),%eax
801042b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801042bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
801042be:	85 c9                	test   %ecx,%ecx
801042c0:	7e 1d                	jle    801042df <safestrcpy+0x2f>
801042c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801042c6:	89 c1                	mov    %eax,%ecx
801042c8:	eb 0e                	jmp    801042d8 <safestrcpy+0x28>
801042ca:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801042cc:	42                   	inc    %edx
801042cd:	41                   	inc    %ecx
801042ce:	8a 5a ff             	mov    -0x1(%edx),%bl
801042d1:	88 59 ff             	mov    %bl,-0x1(%ecx)
801042d4:	84 db                	test   %bl,%bl
801042d6:	74 04                	je     801042dc <safestrcpy+0x2c>
801042d8:	39 f2                	cmp    %esi,%edx
801042da:	75 f0                	jne    801042cc <safestrcpy+0x1c>
    ;
  *s = 0;
801042dc:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801042df:	5b                   	pop    %ebx
801042e0:	5e                   	pop    %esi
801042e1:	5d                   	pop    %ebp
801042e2:	c3                   	ret    
801042e3:	90                   	nop

801042e4 <strlen>:

int
strlen(const char *s)
{
801042e4:	55                   	push   %ebp
801042e5:	89 e5                	mov    %esp,%ebp
801042e7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801042ea:	31 c0                	xor    %eax,%eax
801042ec:	80 3a 00             	cmpb   $0x0,(%edx)
801042ef:	74 0a                	je     801042fb <strlen+0x17>
801042f1:	8d 76 00             	lea    0x0(%esi),%esi
801042f4:	40                   	inc    %eax
801042f5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801042f9:	75 f9                	jne    801042f4 <strlen+0x10>
    ;
  return n;
}
801042fb:	5d                   	pop    %ebp
801042fc:	c3                   	ret    

801042fd <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801042fd:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104301:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104305:	55                   	push   %ebp
  pushl %ebx
80104306:	53                   	push   %ebx
  pushl %esi
80104307:	56                   	push   %esi
  pushl %edi
80104308:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104309:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010430b:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010430d:	5f                   	pop    %edi
  popl %esi
8010430e:	5e                   	pop    %esi
  popl %ebx
8010430f:	5b                   	pop    %ebx
  popl %ebp
80104310:	5d                   	pop    %ebp
  ret
80104311:	c3                   	ret    
80104312:	66 90                	xchg   %ax,%ax

80104314 <fetchint>:
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	51                   	push   %ecx
80104319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010431c:	e8 43 f0 ff ff       	call   80103364 <myproc>

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104321:	8b 00                	mov    (%eax),%eax
80104323:	39 d8                	cmp    %ebx,%eax
80104325:	76 15                	jbe    8010433c <fetchint+0x28>
80104327:	8d 53 04             	lea    0x4(%ebx),%edx
8010432a:	39 d0                	cmp    %edx,%eax
8010432c:	72 0e                	jb     8010433c <fetchint+0x28>
    return -1;
  *ip = *(int *)(addr);
8010432e:	8b 13                	mov    (%ebx),%edx
80104330:	8b 45 0c             	mov    0xc(%ebp),%eax
80104333:	89 10                	mov    %edx,(%eax)
  return 0;
80104335:	31 c0                	xor    %eax,%eax
}
80104337:	5a                   	pop    %edx
80104338:	5b                   	pop    %ebx
80104339:	5d                   	pop    %ebp
8010433a:	c3                   	ret    
8010433b:	90                   	nop
    return -1;
8010433c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104341:	eb f4                	jmp    80104337 <fetchint+0x23>
80104343:	90                   	nop

80104344 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	53                   	push   %ebx
80104348:	51                   	push   %ecx
80104349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010434c:	e8 13 f0 ff ff       	call   80103364 <myproc>

  if (addr >= curproc->sz)
80104351:	39 18                	cmp    %ebx,(%eax)
80104353:	76 1f                	jbe    80104374 <fetchstr+0x30>
    return -1;
  *pp = (char *)addr;
80104355:	8b 55 0c             	mov    0xc(%ebp),%edx
80104358:	89 1a                	mov    %ebx,(%edx)
  ep = (char *)curproc->sz;
8010435a:	8b 10                	mov    (%eax),%edx
  for (s = *pp; s < ep; s++)
8010435c:	39 d3                	cmp    %edx,%ebx
8010435e:	73 14                	jae    80104374 <fetchstr+0x30>
80104360:	89 d8                	mov    %ebx,%eax
80104362:	eb 05                	jmp    80104369 <fetchstr+0x25>
80104364:	40                   	inc    %eax
80104365:	39 c2                	cmp    %eax,%edx
80104367:	76 0b                	jbe    80104374 <fetchstr+0x30>
  {
    if (*s == 0)
80104369:	80 38 00             	cmpb   $0x0,(%eax)
8010436c:	75 f6                	jne    80104364 <fetchstr+0x20>
      return s - *pp;
8010436e:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104370:	5a                   	pop    %edx
80104371:	5b                   	pop    %ebx
80104372:	5d                   	pop    %ebp
80104373:	c3                   	ret    
    return -1;
80104374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104379:	5a                   	pop    %edx
8010437a:	5b                   	pop    %ebx
8010437b:	5d                   	pop    %ebp
8010437c:	c3                   	ret    
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104385:	e8 da ef ff ff       	call   80103364 <myproc>
8010438a:	8b 40 20             	mov    0x20(%eax),%eax
8010438d:	8b 40 44             	mov    0x44(%eax),%eax
80104390:	8b 55 08             	mov    0x8(%ebp),%edx
80104393:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104396:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104399:	e8 c6 ef ff ff       	call   80103364 <myproc>
  if (addr >= curproc->sz || addr + 4 > curproc->sz)
8010439e:	8b 00                	mov    (%eax),%eax
801043a0:	39 c6                	cmp    %eax,%esi
801043a2:	73 18                	jae    801043bc <argint+0x3c>
801043a4:	8d 53 08             	lea    0x8(%ebx),%edx
801043a7:	39 d0                	cmp    %edx,%eax
801043a9:	72 11                	jb     801043bc <argint+0x3c>
  *ip = *(int *)(addr);
801043ab:	8b 53 04             	mov    0x4(%ebx),%edx
801043ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801043b1:	89 10                	mov    %edx,(%eax)
  return 0;
801043b3:	31 c0                	xor    %eax,%eax
}
801043b5:	5b                   	pop    %ebx
801043b6:	5e                   	pop    %esi
801043b7:	5d                   	pop    %ebp
801043b8:	c3                   	ret    
801043b9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801043bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801043c1:	eb f2                	jmp    801043b5 <argint+0x35>
801043c3:	90                   	nop

801043c4 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	56                   	push   %esi
801043c8:	53                   	push   %ebx
801043c9:	83 ec 10             	sub    $0x10,%esp
801043cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801043cf:	e8 90 ef ff ff       	call   80103364 <myproc>
801043d4:	89 c6                	mov    %eax,%esi

  if (argint(n, &i) < 0)
801043d6:	83 ec 08             	sub    $0x8,%esp
801043d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801043dc:	50                   	push   %eax
801043dd:	ff 75 08             	pushl  0x8(%ebp)
801043e0:	e8 9b ff ff ff       	call   80104380 <argint>
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	85 c0                	test   %eax,%eax
801043ea:	78 24                	js     80104410 <argptr+0x4c>
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
801043ec:	85 db                	test   %ebx,%ebx
801043ee:	78 20                	js     80104410 <argptr+0x4c>
801043f0:	8b 16                	mov    (%esi),%edx
801043f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f5:	39 c2                	cmp    %eax,%edx
801043f7:	76 17                	jbe    80104410 <argptr+0x4c>
801043f9:	01 c3                	add    %eax,%ebx
801043fb:	39 da                	cmp    %ebx,%edx
801043fd:	72 11                	jb     80104410 <argptr+0x4c>
    return -1;
  *pp = (char *)i;
801043ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104402:	89 02                	mov    %eax,(%edx)
  return 0;
80104404:	31 c0                	xor    %eax,%eax
}
80104406:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104409:	5b                   	pop    %ebx
8010440a:	5e                   	pop    %esi
8010440b:	5d                   	pop    %ebp
8010440c:	c3                   	ret    
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104415:	eb ef                	jmp    80104406 <argptr+0x42>
80104417:	90                   	nop

80104418 <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
80104418:	55                   	push   %ebp
80104419:	89 e5                	mov    %esp,%ebp
8010441b:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if (argint(n, &addr) < 0)
8010441e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104421:	50                   	push   %eax
80104422:	ff 75 08             	pushl  0x8(%ebp)
80104425:	e8 56 ff ff ff       	call   80104380 <argint>
8010442a:	83 c4 10             	add    $0x10,%esp
8010442d:	85 c0                	test   %eax,%eax
8010442f:	78 13                	js     80104444 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104431:	83 ec 08             	sub    $0x8,%esp
80104434:	ff 75 0c             	pushl  0xc(%ebp)
80104437:	ff 75 f4             	pushl  -0xc(%ebp)
8010443a:	e8 05 ff ff ff       	call   80104344 <fetchstr>
8010443f:	83 c4 10             	add    $0x10,%esp
}
80104442:	c9                   	leave  
80104443:	c3                   	ret    
    return -1;
80104444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104449:	c9                   	leave  
8010444a:	c3                   	ret    
8010444b:	90                   	nop

8010444c <syscall>:
    [SYS_settickets] sys_settickets,
    [SYS_getpinfo] sys_getpinfo,
};

void syscall(void)
{
8010444c:	55                   	push   %ebp
8010444d:	89 e5                	mov    %esp,%ebp
8010444f:	53                   	push   %ebx
80104450:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
80104451:	e8 0e ef ff ff       	call   80103364 <myproc>
80104456:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104458:	8b 40 20             	mov    0x20(%eax),%eax
8010445b:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
8010445e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104461:	83 fa 16             	cmp    $0x16,%edx
80104464:	77 1a                	ja     80104480 <syscall+0x34>
80104466:	8b 14 85 40 6f 10 80 	mov    -0x7fef90c0(,%eax,4),%edx
8010446d:	85 d2                	test   %edx,%edx
8010446f:	74 0f                	je     80104480 <syscall+0x34>
  {
    curproc->tf->eax = syscalls[num]();
80104471:	ff d2                	call   *%edx
80104473:	8b 53 20             	mov    0x20(%ebx),%edx
80104476:	89 42 1c             	mov    %eax,0x1c(%edx)
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447c:	c9                   	leave  
8010447d:	c3                   	ret    
8010447e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104480:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104481:	8d 43 74             	lea    0x74(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104484:	50                   	push   %eax
80104485:	ff 73 18             	pushl  0x18(%ebx)
80104488:	68 19 6f 10 80       	push   $0x80106f19
8010448d:	e8 8e c1 ff ff       	call   80100620 <cprintf>
    curproc->tf->eax = -1;
80104492:	8b 43 20             	mov    0x20(%ebx),%eax
80104495:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010449c:	83 c4 10             	add    $0x10,%esp
}
8010449f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a2:	c9                   	leave  
801044a3:	c3                   	ret    

801044a4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	56                   	push   %esi
801044a9:	53                   	push   %ebx
801044aa:	83 ec 34             	sub    $0x34,%esp
801044ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801044b0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801044b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044b6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801044b9:	8d 7d da             	lea    -0x26(%ebp),%edi
801044bc:	57                   	push   %edi
801044bd:	50                   	push   %eax
801044be:	e8 65 d8 ff ff       	call   80101d28 <nameiparent>
801044c3:	83 c4 10             	add    $0x10,%esp
801044c6:	85 c0                	test   %eax,%eax
801044c8:	0f 84 22 01 00 00    	je     801045f0 <create+0x14c>
801044ce:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	50                   	push   %eax
801044d4:	e8 83 d0 ff ff       	call   8010155c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801044d9:	83 c4 0c             	add    $0xc,%esp
801044dc:	6a 00                	push   $0x0
801044de:	57                   	push   %edi
801044df:	53                   	push   %ebx
801044e0:	e8 4b d5 ff ff       	call   80101a30 <dirlookup>
801044e5:	89 c6                	mov    %eax,%esi
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	85 c0                	test   %eax,%eax
801044ec:	74 46                	je     80104534 <create+0x90>
    iunlockput(dp);
801044ee:	83 ec 0c             	sub    $0xc,%esp
801044f1:	53                   	push   %ebx
801044f2:	e8 bd d2 ff ff       	call   801017b4 <iunlockput>
    ilock(ip);
801044f7:	89 34 24             	mov    %esi,(%esp)
801044fa:	e8 5d d0 ff ff       	call   8010155c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801044ff:	83 c4 10             	add    $0x10,%esp
80104502:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104507:	75 13                	jne    8010451c <create+0x78>
80104509:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010450e:	75 0c                	jne    8010451c <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104510:	89 f0                	mov    %esi,%eax
80104512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104515:	5b                   	pop    %ebx
80104516:	5e                   	pop    %esi
80104517:	5f                   	pop    %edi
80104518:	5d                   	pop    %ebp
80104519:	c3                   	ret    
8010451a:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	56                   	push   %esi
80104520:	e8 8f d2 ff ff       	call   801017b4 <iunlockput>
    return 0;
80104525:	83 c4 10             	add    $0x10,%esp
80104528:	31 f6                	xor    %esi,%esi
}
8010452a:	89 f0                	mov    %esi,%eax
8010452c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010452f:	5b                   	pop    %ebx
80104530:	5e                   	pop    %esi
80104531:	5f                   	pop    %edi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104534:	83 ec 08             	sub    $0x8,%esp
80104537:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010453b:	50                   	push   %eax
8010453c:	ff 33                	pushl  (%ebx)
8010453e:	e8 c1 ce ff ff       	call   80101404 <ialloc>
80104543:	89 c6                	mov    %eax,%esi
80104545:	83 c4 10             	add    $0x10,%esp
80104548:	85 c0                	test   %eax,%eax
8010454a:	0f 84 b9 00 00 00    	je     80104609 <create+0x165>
  ilock(ip);
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	50                   	push   %eax
80104554:	e8 03 d0 ff ff       	call   8010155c <ilock>
  ip->major = major;
80104559:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010455c:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104560:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104563:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104567:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
8010456d:	89 34 24             	mov    %esi,(%esp)
80104570:	e8 3f cf ff ff       	call   801014b4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104575:	83 c4 10             	add    $0x10,%esp
80104578:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010457d:	74 29                	je     801045a8 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
8010457f:	50                   	push   %eax
80104580:	ff 76 04             	pushl  0x4(%esi)
80104583:	57                   	push   %edi
80104584:	53                   	push   %ebx
80104585:	e8 d6 d6 ff ff       	call   80101c60 <dirlink>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	85 c0                	test   %eax,%eax
8010458f:	78 6b                	js     801045fc <create+0x158>
  iunlockput(dp);
80104591:	83 ec 0c             	sub    $0xc,%esp
80104594:	53                   	push   %ebx
80104595:	e8 1a d2 ff ff       	call   801017b4 <iunlockput>
  return ip;
8010459a:	83 c4 10             	add    $0x10,%esp
}
8010459d:	89 f0                	mov    %esi,%eax
8010459f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a2:	5b                   	pop    %ebx
801045a3:	5e                   	pop    %esi
801045a4:	5f                   	pop    %edi
801045a5:	5d                   	pop    %ebp
801045a6:	c3                   	ret    
801045a7:	90                   	nop
    dp->nlink++;  // for ".."
801045a8:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
801045ac:	83 ec 0c             	sub    $0xc,%esp
801045af:	53                   	push   %ebx
801045b0:	e8 ff ce ff ff       	call   801014b4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801045b5:	83 c4 0c             	add    $0xc,%esp
801045b8:	ff 76 04             	pushl  0x4(%esi)
801045bb:	68 bc 6f 10 80       	push   $0x80106fbc
801045c0:	56                   	push   %esi
801045c1:	e8 9a d6 ff ff       	call   80101c60 <dirlink>
801045c6:	83 c4 10             	add    $0x10,%esp
801045c9:	85 c0                	test   %eax,%eax
801045cb:	78 16                	js     801045e3 <create+0x13f>
801045cd:	52                   	push   %edx
801045ce:	ff 73 04             	pushl  0x4(%ebx)
801045d1:	68 bb 6f 10 80       	push   $0x80106fbb
801045d6:	56                   	push   %esi
801045d7:	e8 84 d6 ff ff       	call   80101c60 <dirlink>
801045dc:	83 c4 10             	add    $0x10,%esp
801045df:	85 c0                	test   %eax,%eax
801045e1:	79 9c                	jns    8010457f <create+0xdb>
      panic("create dots");
801045e3:	83 ec 0c             	sub    $0xc,%esp
801045e6:	68 af 6f 10 80       	push   $0x80106faf
801045eb:	e8 50 bd ff ff       	call   80100340 <panic>
    return 0;
801045f0:	31 f6                	xor    %esi,%esi
}
801045f2:	89 f0                	mov    %esi,%eax
801045f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045f7:	5b                   	pop    %ebx
801045f8:	5e                   	pop    %esi
801045f9:	5f                   	pop    %edi
801045fa:	5d                   	pop    %ebp
801045fb:	c3                   	ret    
    panic("create: dirlink");
801045fc:	83 ec 0c             	sub    $0xc,%esp
801045ff:	68 be 6f 10 80       	push   $0x80106fbe
80104604:	e8 37 bd ff ff       	call   80100340 <panic>
    panic("create: ialloc");
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	68 a0 6f 10 80       	push   $0x80106fa0
80104611:	e8 2a bd ff ff       	call   80100340 <panic>
80104616:	66 90                	xchg   %ax,%ax

80104618 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104618:	55                   	push   %ebp
80104619:	89 e5                	mov    %esp,%ebp
8010461b:	56                   	push   %esi
8010461c:	53                   	push   %ebx
8010461d:	83 ec 18             	sub    $0x18,%esp
80104620:	89 c3                	mov    %eax,%ebx
80104622:	89 d6                	mov    %edx,%esi
  if(argint(n, &fd) < 0)
80104624:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104627:	50                   	push   %eax
80104628:	6a 00                	push   $0x0
8010462a:	e8 51 fd ff ff       	call   80104380 <argint>
8010462f:	83 c4 10             	add    $0x10,%esp
80104632:	85 c0                	test   %eax,%eax
80104634:	78 2a                	js     80104660 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104636:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010463a:	77 24                	ja     80104660 <argfd.constprop.0+0x48>
8010463c:	e8 23 ed ff ff       	call   80103364 <myproc>
80104641:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104644:	8b 44 90 30          	mov    0x30(%eax,%edx,4),%eax
80104648:	85 c0                	test   %eax,%eax
8010464a:	74 14                	je     80104660 <argfd.constprop.0+0x48>
  if(pfd)
8010464c:	85 db                	test   %ebx,%ebx
8010464e:	74 02                	je     80104652 <argfd.constprop.0+0x3a>
    *pfd = fd;
80104650:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104652:	89 06                	mov    %eax,(%esi)
  return 0;
80104654:	31 c0                	xor    %eax,%eax
}
80104656:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104659:	5b                   	pop    %ebx
8010465a:	5e                   	pop    %esi
8010465b:	5d                   	pop    %ebp
8010465c:	c3                   	ret    
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104665:	eb ef                	jmp    80104656 <argfd.constprop.0+0x3e>
80104667:	90                   	nop

80104668 <sys_dup>:
{
80104668:	55                   	push   %ebp
80104669:	89 e5                	mov    %esp,%ebp
8010466b:	56                   	push   %esi
8010466c:	53                   	push   %ebx
8010466d:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104670:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104673:	31 c0                	xor    %eax,%eax
80104675:	e8 9e ff ff ff       	call   80104618 <argfd.constprop.0>
8010467a:	85 c0                	test   %eax,%eax
8010467c:	78 18                	js     80104696 <sys_dup+0x2e>
  if((fd=fdalloc(f)) < 0)
8010467e:	8b 75 f4             	mov    -0xc(%ebp),%esi
  struct proc *curproc = myproc();
80104681:	e8 de ec ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104686:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80104688:	8b 54 98 30          	mov    0x30(%eax,%ebx,4),%edx
8010468c:	85 d2                	test   %edx,%edx
8010468e:	74 14                	je     801046a4 <sys_dup+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
80104690:	43                   	inc    %ebx
80104691:	83 fb 10             	cmp    $0x10,%ebx
80104694:	75 f2                	jne    80104688 <sys_dup+0x20>
    return -1;
80104696:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
8010469b:	89 d8                	mov    %ebx,%eax
8010469d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a0:	5b                   	pop    %ebx
801046a1:	5e                   	pop    %esi
801046a2:	5d                   	pop    %ebp
801046a3:	c3                   	ret    
      curproc->ofile[fd] = f;
801046a4:	89 74 98 30          	mov    %esi,0x30(%eax,%ebx,4)
  filedup(f);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	ff 75 f4             	pushl  -0xc(%ebp)
801046ae:	e8 a5 c6 ff ff       	call   80100d58 <filedup>
  return fd;
801046b3:	83 c4 10             	add    $0x10,%esp
}
801046b6:	89 d8                	mov    %ebx,%eax
801046b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046bb:	5b                   	pop    %ebx
801046bc:	5e                   	pop    %esi
801046bd:	5d                   	pop    %ebp
801046be:	c3                   	ret    
801046bf:	90                   	nop

801046c0 <sys_read>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801046c6:	8d 55 ec             	lea    -0x14(%ebp),%edx
801046c9:	31 c0                	xor    %eax,%eax
801046cb:	e8 48 ff ff ff       	call   80104618 <argfd.constprop.0>
801046d0:	85 c0                	test   %eax,%eax
801046d2:	78 40                	js     80104714 <sys_read+0x54>
801046d4:	83 ec 08             	sub    $0x8,%esp
801046d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046da:	50                   	push   %eax
801046db:	6a 02                	push   $0x2
801046dd:	e8 9e fc ff ff       	call   80104380 <argint>
801046e2:	83 c4 10             	add    $0x10,%esp
801046e5:	85 c0                	test   %eax,%eax
801046e7:	78 2b                	js     80104714 <sys_read+0x54>
801046e9:	52                   	push   %edx
801046ea:	ff 75 f0             	pushl  -0x10(%ebp)
801046ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046f0:	50                   	push   %eax
801046f1:	6a 01                	push   $0x1
801046f3:	e8 cc fc ff ff       	call   801043c4 <argptr>
801046f8:	83 c4 10             	add    $0x10,%esp
801046fb:	85 c0                	test   %eax,%eax
801046fd:	78 15                	js     80104714 <sys_read+0x54>
  return fileread(f, p, n);
801046ff:	50                   	push   %eax
80104700:	ff 75 f0             	pushl  -0x10(%ebp)
80104703:	ff 75 f4             	pushl  -0xc(%ebp)
80104706:	ff 75 ec             	pushl  -0x14(%ebp)
80104709:	e8 92 c7 ff ff       	call   80100ea0 <fileread>
8010470e:	83 c4 10             	add    $0x10,%esp
}
80104711:	c9                   	leave  
80104712:	c3                   	ret    
80104713:	90                   	nop
    return -1;
80104714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104719:	c9                   	leave  
8010471a:	c3                   	ret    
8010471b:	90                   	nop

8010471c <sys_write>:
{
8010471c:	55                   	push   %ebp
8010471d:	89 e5                	mov    %esp,%ebp
8010471f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104722:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104725:	31 c0                	xor    %eax,%eax
80104727:	e8 ec fe ff ff       	call   80104618 <argfd.constprop.0>
8010472c:	85 c0                	test   %eax,%eax
8010472e:	78 40                	js     80104770 <sys_write+0x54>
80104730:	83 ec 08             	sub    $0x8,%esp
80104733:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104736:	50                   	push   %eax
80104737:	6a 02                	push   $0x2
80104739:	e8 42 fc ff ff       	call   80104380 <argint>
8010473e:	83 c4 10             	add    $0x10,%esp
80104741:	85 c0                	test   %eax,%eax
80104743:	78 2b                	js     80104770 <sys_write+0x54>
80104745:	52                   	push   %edx
80104746:	ff 75 f0             	pushl  -0x10(%ebp)
80104749:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010474c:	50                   	push   %eax
8010474d:	6a 01                	push   $0x1
8010474f:	e8 70 fc ff ff       	call   801043c4 <argptr>
80104754:	83 c4 10             	add    $0x10,%esp
80104757:	85 c0                	test   %eax,%eax
80104759:	78 15                	js     80104770 <sys_write+0x54>
  return filewrite(f, p, n);
8010475b:	50                   	push   %eax
8010475c:	ff 75 f0             	pushl  -0x10(%ebp)
8010475f:	ff 75 f4             	pushl  -0xc(%ebp)
80104762:	ff 75 ec             	pushl  -0x14(%ebp)
80104765:	e8 c2 c7 ff ff       	call   80100f2c <filewrite>
8010476a:	83 c4 10             	add    $0x10,%esp
}
8010476d:	c9                   	leave  
8010476e:	c3                   	ret    
8010476f:	90                   	nop
    return -1;
80104770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104775:	c9                   	leave  
80104776:	c3                   	ret    
80104777:	90                   	nop

80104778 <sys_close>:
{
80104778:	55                   	push   %ebp
80104779:	89 e5                	mov    %esp,%ebp
8010477b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010477e:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104781:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104784:	e8 8f fe ff ff       	call   80104618 <argfd.constprop.0>
80104789:	85 c0                	test   %eax,%eax
8010478b:	78 23                	js     801047b0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
8010478d:	e8 d2 eb ff ff       	call   80103364 <myproc>
80104792:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104795:	c7 44 90 30 00 00 00 	movl   $0x0,0x30(%eax,%edx,4)
8010479c:	00 
  fileclose(f);
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	ff 75 f4             	pushl  -0xc(%ebp)
801047a3:	e8 f4 c5 ff ff       	call   80100d9c <fileclose>
  return 0;
801047a8:	83 c4 10             	add    $0x10,%esp
801047ab:	31 c0                	xor    %eax,%eax
}
801047ad:	c9                   	leave  
801047ae:	c3                   	ret    
801047af:	90                   	nop
    return -1;
801047b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047b5:	c9                   	leave  
801047b6:	c3                   	ret    
801047b7:	90                   	nop

801047b8 <sys_fstat>:
{
801047b8:	55                   	push   %ebp
801047b9:	89 e5                	mov    %esp,%ebp
801047bb:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801047be:	8d 55 f0             	lea    -0x10(%ebp),%edx
801047c1:	31 c0                	xor    %eax,%eax
801047c3:	e8 50 fe ff ff       	call   80104618 <argfd.constprop.0>
801047c8:	85 c0                	test   %eax,%eax
801047ca:	78 28                	js     801047f4 <sys_fstat+0x3c>
801047cc:	50                   	push   %eax
801047cd:	6a 14                	push   $0x14
801047cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047d2:	50                   	push   %eax
801047d3:	6a 01                	push   $0x1
801047d5:	e8 ea fb ff ff       	call   801043c4 <argptr>
801047da:	83 c4 10             	add    $0x10,%esp
801047dd:	85 c0                	test   %eax,%eax
801047df:	78 13                	js     801047f4 <sys_fstat+0x3c>
  return filestat(f, st);
801047e1:	83 ec 08             	sub    $0x8,%esp
801047e4:	ff 75 f4             	pushl  -0xc(%ebp)
801047e7:	ff 75 f0             	pushl  -0x10(%ebp)
801047ea:	e8 6d c6 ff ff       	call   80100e5c <filestat>
801047ef:	83 c4 10             	add    $0x10,%esp
}
801047f2:	c9                   	leave  
801047f3:	c3                   	ret    
    return -1;
801047f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047f9:	c9                   	leave  
801047fa:	c3                   	ret    
801047fb:	90                   	nop

801047fc <sys_link>:
{
801047fc:	55                   	push   %ebp
801047fd:	89 e5                	mov    %esp,%ebp
801047ff:	57                   	push   %edi
80104800:	56                   	push   %esi
80104801:	53                   	push   %ebx
80104802:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104805:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104808:	50                   	push   %eax
80104809:	6a 00                	push   $0x0
8010480b:	e8 08 fc ff ff       	call   80104418 <argstr>
80104810:	83 c4 10             	add    $0x10,%esp
80104813:	85 c0                	test   %eax,%eax
80104815:	0f 88 f2 00 00 00    	js     8010490d <sys_link+0x111>
8010481b:	83 ec 08             	sub    $0x8,%esp
8010481e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104821:	50                   	push   %eax
80104822:	6a 01                	push   $0x1
80104824:	e8 ef fb ff ff       	call   80104418 <argstr>
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	0f 88 d9 00 00 00    	js     8010490d <sys_link+0x111>
  begin_op();
80104834:	e8 03 e0 ff ff       	call   8010283c <begin_op>
  if((ip = namei(old)) == 0){
80104839:	83 ec 0c             	sub    $0xc,%esp
8010483c:	ff 75 d4             	pushl  -0x2c(%ebp)
8010483f:	e8 cc d4 ff ff       	call   80101d10 <namei>
80104844:	89 c3                	mov    %eax,%ebx
80104846:	83 c4 10             	add    $0x10,%esp
80104849:	85 c0                	test   %eax,%eax
8010484b:	0f 84 db 00 00 00    	je     8010492c <sys_link+0x130>
  ilock(ip);
80104851:	83 ec 0c             	sub    $0xc,%esp
80104854:	50                   	push   %eax
80104855:	e8 02 cd ff ff       	call   8010155c <ilock>
  if(ip->type == T_DIR){
8010485a:	83 c4 10             	add    $0x10,%esp
8010485d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104862:	0f 84 ac 00 00 00    	je     80104914 <sys_link+0x118>
  ip->nlink++;
80104868:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
8010486c:	83 ec 0c             	sub    $0xc,%esp
8010486f:	53                   	push   %ebx
80104870:	e8 3f cc ff ff       	call   801014b4 <iupdate>
  iunlock(ip);
80104875:	89 1c 24             	mov    %ebx,(%esp)
80104878:	e8 a7 cd ff ff       	call   80101624 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010487d:	5a                   	pop    %edx
8010487e:	59                   	pop    %ecx
8010487f:	8d 7d da             	lea    -0x26(%ebp),%edi
80104882:	57                   	push   %edi
80104883:	ff 75 d0             	pushl  -0x30(%ebp)
80104886:	e8 9d d4 ff ff       	call   80101d28 <nameiparent>
8010488b:	89 c6                	mov    %eax,%esi
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	85 c0                	test   %eax,%eax
80104892:	74 54                	je     801048e8 <sys_link+0xec>
  ilock(dp);
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	50                   	push   %eax
80104898:	e8 bf cc ff ff       	call   8010155c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010489d:	83 c4 10             	add    $0x10,%esp
801048a0:	8b 03                	mov    (%ebx),%eax
801048a2:	39 06                	cmp    %eax,(%esi)
801048a4:	75 36                	jne    801048dc <sys_link+0xe0>
801048a6:	50                   	push   %eax
801048a7:	ff 73 04             	pushl  0x4(%ebx)
801048aa:	57                   	push   %edi
801048ab:	56                   	push   %esi
801048ac:	e8 af d3 ff ff       	call   80101c60 <dirlink>
801048b1:	83 c4 10             	add    $0x10,%esp
801048b4:	85 c0                	test   %eax,%eax
801048b6:	78 24                	js     801048dc <sys_link+0xe0>
  iunlockput(dp);
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	56                   	push   %esi
801048bc:	e8 f3 ce ff ff       	call   801017b4 <iunlockput>
  iput(ip);
801048c1:	89 1c 24             	mov    %ebx,(%esp)
801048c4:	e8 9f cd ff ff       	call   80101668 <iput>
  end_op();
801048c9:	e8 d6 df ff ff       	call   801028a4 <end_op>
  return 0;
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	31 c0                	xor    %eax,%eax
}
801048d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048d6:	5b                   	pop    %ebx
801048d7:	5e                   	pop    %esi
801048d8:	5f                   	pop    %edi
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    
801048db:	90                   	nop
    iunlockput(dp);
801048dc:	83 ec 0c             	sub    $0xc,%esp
801048df:	56                   	push   %esi
801048e0:	e8 cf ce ff ff       	call   801017b4 <iunlockput>
    goto bad;
801048e5:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	53                   	push   %ebx
801048ec:	e8 6b cc ff ff       	call   8010155c <ilock>
  ip->nlink--;
801048f1:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801048f5:	89 1c 24             	mov    %ebx,(%esp)
801048f8:	e8 b7 cb ff ff       	call   801014b4 <iupdate>
  iunlockput(ip);
801048fd:	89 1c 24             	mov    %ebx,(%esp)
80104900:	e8 af ce ff ff       	call   801017b4 <iunlockput>
  end_op();
80104905:	e8 9a df ff ff       	call   801028a4 <end_op>
  return -1;
8010490a:	83 c4 10             	add    $0x10,%esp
8010490d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104912:	eb bf                	jmp    801048d3 <sys_link+0xd7>
    iunlockput(ip);
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	53                   	push   %ebx
80104918:	e8 97 ce ff ff       	call   801017b4 <iunlockput>
    end_op();
8010491d:	e8 82 df ff ff       	call   801028a4 <end_op>
    return -1;
80104922:	83 c4 10             	add    $0x10,%esp
80104925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010492a:	eb a7                	jmp    801048d3 <sys_link+0xd7>
    end_op();
8010492c:	e8 73 df ff ff       	call   801028a4 <end_op>
    return -1;
80104931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104936:	eb 9b                	jmp    801048d3 <sys_link+0xd7>

80104938 <sys_unlink>:
{
80104938:	55                   	push   %ebp
80104939:	89 e5                	mov    %esp,%ebp
8010493b:	57                   	push   %edi
8010493c:	56                   	push   %esi
8010493d:	53                   	push   %ebx
8010493e:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104941:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104944:	50                   	push   %eax
80104945:	6a 00                	push   $0x0
80104947:	e8 cc fa ff ff       	call   80104418 <argstr>
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	85 c0                	test   %eax,%eax
80104951:	0f 88 69 01 00 00    	js     80104ac0 <sys_unlink+0x188>
  begin_op();
80104957:	e8 e0 de ff ff       	call   8010283c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010495c:	83 ec 08             	sub    $0x8,%esp
8010495f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104962:	53                   	push   %ebx
80104963:	ff 75 c0             	pushl  -0x40(%ebp)
80104966:	e8 bd d3 ff ff       	call   80101d28 <nameiparent>
8010496b:	89 c6                	mov    %eax,%esi
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	85 c0                	test   %eax,%eax
80104972:	0f 84 52 01 00 00    	je     80104aca <sys_unlink+0x192>
  ilock(dp);
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	50                   	push   %eax
8010497c:	e8 db cb ff ff       	call   8010155c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104981:	59                   	pop    %ecx
80104982:	5f                   	pop    %edi
80104983:	68 bc 6f 10 80       	push   $0x80106fbc
80104988:	53                   	push   %ebx
80104989:	e8 8a d0 ff ff       	call   80101a18 <namecmp>
8010498e:	83 c4 10             	add    $0x10,%esp
80104991:	85 c0                	test   %eax,%eax
80104993:	0f 84 f7 00 00 00    	je     80104a90 <sys_unlink+0x158>
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	68 bb 6f 10 80       	push   $0x80106fbb
801049a1:	53                   	push   %ebx
801049a2:	e8 71 d0 ff ff       	call   80101a18 <namecmp>
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	85 c0                	test   %eax,%eax
801049ac:	0f 84 de 00 00 00    	je     80104a90 <sys_unlink+0x158>
  if((ip = dirlookup(dp, name, &off)) == 0)
801049b2:	52                   	push   %edx
801049b3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801049b6:	50                   	push   %eax
801049b7:	53                   	push   %ebx
801049b8:	56                   	push   %esi
801049b9:	e8 72 d0 ff ff       	call   80101a30 <dirlookup>
801049be:	89 c3                	mov    %eax,%ebx
801049c0:	83 c4 10             	add    $0x10,%esp
801049c3:	85 c0                	test   %eax,%eax
801049c5:	0f 84 c5 00 00 00    	je     80104a90 <sys_unlink+0x158>
  ilock(ip);
801049cb:	83 ec 0c             	sub    $0xc,%esp
801049ce:	50                   	push   %eax
801049cf:	e8 88 cb ff ff       	call   8010155c <ilock>
  if(ip->nlink < 1)
801049d4:	83 c4 10             	add    $0x10,%esp
801049d7:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801049dc:	0f 8e 11 01 00 00    	jle    80104af3 <sys_unlink+0x1bb>
  if(ip->type == T_DIR && !isdirempty(ip)){
801049e2:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049e7:	74 63                	je     80104a4c <sys_unlink+0x114>
801049e9:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
801049ec:	50                   	push   %eax
801049ed:	6a 10                	push   $0x10
801049ef:	6a 00                	push   $0x0
801049f1:	57                   	push   %edi
801049f2:	e8 65 f7 ff ff       	call   8010415c <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801049f7:	6a 10                	push   $0x10
801049f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801049fc:	57                   	push   %edi
801049fd:	56                   	push   %esi
801049fe:	e8 f5 ce ff ff       	call   801018f8 <writei>
80104a03:	83 c4 20             	add    $0x20,%esp
80104a06:	83 f8 10             	cmp    $0x10,%eax
80104a09:	0f 85 d7 00 00 00    	jne    80104ae6 <sys_unlink+0x1ae>
  if(ip->type == T_DIR){
80104a0f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a14:	0f 84 8e 00 00 00    	je     80104aa8 <sys_unlink+0x170>
  iunlockput(dp);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
80104a1d:	56                   	push   %esi
80104a1e:	e8 91 cd ff ff       	call   801017b4 <iunlockput>
  ip->nlink--;
80104a23:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
80104a27:	89 1c 24             	mov    %ebx,(%esp)
80104a2a:	e8 85 ca ff ff       	call   801014b4 <iupdate>
  iunlockput(ip);
80104a2f:	89 1c 24             	mov    %ebx,(%esp)
80104a32:	e8 7d cd ff ff       	call   801017b4 <iunlockput>
  end_op();
80104a37:	e8 68 de ff ff       	call   801028a4 <end_op>
  return 0;
80104a3c:	83 c4 10             	add    $0x10,%esp
80104a3f:	31 c0                	xor    %eax,%eax
}
80104a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a44:	5b                   	pop    %ebx
80104a45:	5e                   	pop    %esi
80104a46:	5f                   	pop    %edi
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104a4c:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104a50:	76 97                	jbe    801049e9 <sys_unlink+0xb1>
80104a52:	ba 20 00 00 00       	mov    $0x20,%edx
80104a57:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104a5a:	eb 08                	jmp    80104a64 <sys_unlink+0x12c>
80104a5c:	83 c2 10             	add    $0x10,%edx
80104a5f:	39 53 58             	cmp    %edx,0x58(%ebx)
80104a62:	76 88                	jbe    801049ec <sys_unlink+0xb4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104a64:	6a 10                	push   $0x10
80104a66:	52                   	push   %edx
80104a67:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104a6a:	57                   	push   %edi
80104a6b:	53                   	push   %ebx
80104a6c:	e8 8f cd ff ff       	call   80101800 <readi>
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	83 f8 10             	cmp    $0x10,%eax
80104a77:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80104a7a:	75 5d                	jne    80104ad9 <sys_unlink+0x1a1>
    if(de.inum != 0)
80104a7c:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104a81:	74 d9                	je     80104a5c <sys_unlink+0x124>
    iunlockput(ip);
80104a83:	83 ec 0c             	sub    $0xc,%esp
80104a86:	53                   	push   %ebx
80104a87:	e8 28 cd ff ff       	call   801017b4 <iunlockput>
    goto bad;
80104a8c:	83 c4 10             	add    $0x10,%esp
80104a8f:	90                   	nop
  iunlockput(dp);
80104a90:	83 ec 0c             	sub    $0xc,%esp
80104a93:	56                   	push   %esi
80104a94:	e8 1b cd ff ff       	call   801017b4 <iunlockput>
  end_op();
80104a99:	e8 06 de ff ff       	call   801028a4 <end_op>
  return -1;
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa6:	eb 99                	jmp    80104a41 <sys_unlink+0x109>
    dp->nlink--;
80104aa8:	66 ff 4e 56          	decw   0x56(%esi)
    iupdate(dp);
80104aac:	83 ec 0c             	sub    $0xc,%esp
80104aaf:	56                   	push   %esi
80104ab0:	e8 ff c9 ff ff       	call   801014b4 <iupdate>
80104ab5:	83 c4 10             	add    $0x10,%esp
80104ab8:	e9 5d ff ff ff       	jmp    80104a1a <sys_unlink+0xe2>
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	e9 77 ff ff ff       	jmp    80104a41 <sys_unlink+0x109>
    end_op();
80104aca:	e8 d5 dd ff ff       	call   801028a4 <end_op>
    return -1;
80104acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad4:	e9 68 ff ff ff       	jmp    80104a41 <sys_unlink+0x109>
      panic("isdirempty: readi");
80104ad9:	83 ec 0c             	sub    $0xc,%esp
80104adc:	68 e0 6f 10 80       	push   $0x80106fe0
80104ae1:	e8 5a b8 ff ff       	call   80100340 <panic>
    panic("unlink: writei");
80104ae6:	83 ec 0c             	sub    $0xc,%esp
80104ae9:	68 f2 6f 10 80       	push   $0x80106ff2
80104aee:	e8 4d b8 ff ff       	call   80100340 <panic>
    panic("unlink: nlink < 1");
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	68 ce 6f 10 80       	push   $0x80106fce
80104afb:	e8 40 b8 ff ff       	call   80100340 <panic>

80104b00 <sys_open>:

int
sys_open(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104b08:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b0b:	50                   	push   %eax
80104b0c:	6a 00                	push   $0x0
80104b0e:	e8 05 f9 ff ff       	call   80104418 <argstr>
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	85 c0                	test   %eax,%eax
80104b18:	0f 88 8d 00 00 00    	js     80104bab <sys_open+0xab>
80104b1e:	83 ec 08             	sub    $0x8,%esp
80104b21:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b24:	50                   	push   %eax
80104b25:	6a 01                	push   $0x1
80104b27:	e8 54 f8 ff ff       	call   80104380 <argint>
80104b2c:	83 c4 10             	add    $0x10,%esp
80104b2f:	85 c0                	test   %eax,%eax
80104b31:	78 78                	js     80104bab <sys_open+0xab>
    return -1;

  begin_op();
80104b33:	e8 04 dd ff ff       	call   8010283c <begin_op>

  if(omode & O_CREATE){
80104b38:	f6 45 f5 02          	testb  $0x2,-0xb(%ebp)
80104b3c:	75 76                	jne    80104bb4 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104b3e:	83 ec 0c             	sub    $0xc,%esp
80104b41:	ff 75 f0             	pushl  -0x10(%ebp)
80104b44:	e8 c7 d1 ff ff       	call   80101d10 <namei>
80104b49:	89 c3                	mov    %eax,%ebx
80104b4b:	83 c4 10             	add    $0x10,%esp
80104b4e:	85 c0                	test   %eax,%eax
80104b50:	74 7f                	je     80104bd1 <sys_open+0xd1>
      end_op();
      return -1;
    }
    ilock(ip);
80104b52:	83 ec 0c             	sub    $0xc,%esp
80104b55:	50                   	push   %eax
80104b56:	e8 01 ca ff ff       	call   8010155c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b63:	0f 84 bf 00 00 00    	je     80104c28 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104b69:	e8 8a c1 ff ff       	call   80100cf8 <filealloc>
80104b6e:	89 c6                	mov    %eax,%esi
80104b70:	85 c0                	test   %eax,%eax
80104b72:	74 26                	je     80104b9a <sys_open+0x9a>
  struct proc *curproc = myproc();
80104b74:	e8 eb e7 ff ff       	call   80103364 <myproc>
80104b79:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80104b7b:	31 c0                	xor    %eax,%eax
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104b80:	8b 4c 82 30          	mov    0x30(%edx,%eax,4),%ecx
80104b84:	85 c9                	test   %ecx,%ecx
80104b86:	74 58                	je     80104be0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80104b88:	40                   	inc    %eax
80104b89:	83 f8 10             	cmp    $0x10,%eax
80104b8c:	75 f2                	jne    80104b80 <sys_open+0x80>
    if(f)
      fileclose(f);
80104b8e:	83 ec 0c             	sub    $0xc,%esp
80104b91:	56                   	push   %esi
80104b92:	e8 05 c2 ff ff       	call   80100d9c <fileclose>
80104b97:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	53                   	push   %ebx
80104b9e:	e8 11 cc ff ff       	call   801017b4 <iunlockput>
    end_op();
80104ba3:	e8 fc dc ff ff       	call   801028a4 <end_op>
    return -1;
80104ba8:	83 c4 10             	add    $0x10,%esp
80104bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb0:	eb 6d                	jmp    80104c1f <sys_open+0x11f>
80104bb2:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	6a 00                	push   $0x0
80104bb9:	31 c9                	xor    %ecx,%ecx
80104bbb:	ba 02 00 00 00       	mov    $0x2,%edx
80104bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc3:	e8 dc f8 ff ff       	call   801044a4 <create>
80104bc8:	89 c3                	mov    %eax,%ebx
    if(ip == 0){
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	75 98                	jne    80104b69 <sys_open+0x69>
      end_op();
80104bd1:	e8 ce dc ff ff       	call   801028a4 <end_op>
      return -1;
80104bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bdb:	eb 42                	jmp    80104c1f <sys_open+0x11f>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104be0:	89 74 82 30          	mov    %esi,0x30(%edx,%eax,4)
80104be4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  iunlock(ip);
80104be7:	83 ec 0c             	sub    $0xc,%esp
80104bea:	53                   	push   %ebx
80104beb:	e8 34 ca ff ff       	call   80101624 <iunlock>
  end_op();
80104bf0:	e8 af dc ff ff       	call   801028a4 <end_op>

  f->type = FD_INODE;
80104bf5:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
80104bfb:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
80104bfe:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104c05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104c08:	89 ca                	mov    %ecx,%edx
80104c0a:	f7 d2                	not    %edx
80104c0c:	83 e2 01             	and    $0x1,%edx
80104c0f:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104c12:	83 c4 10             	add    $0x10,%esp
80104c15:	83 e1 03             	and    $0x3,%ecx
80104c18:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
80104c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80104c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c22:	5b                   	pop    %ebx
80104c23:	5e                   	pop    %esi
80104c24:	5d                   	pop    %ebp
80104c25:	c3                   	ret    
80104c26:	66 90                	xchg   %ax,%ax
    if(ip->type == T_DIR && omode != O_RDONLY){
80104c28:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104c2b:	85 f6                	test   %esi,%esi
80104c2d:	0f 84 36 ff ff ff    	je     80104b69 <sys_open+0x69>
80104c33:	e9 62 ff ff ff       	jmp    80104b9a <sys_open+0x9a>

80104c38 <sys_mkdir>:

int
sys_mkdir(void)
{
80104c38:	55                   	push   %ebp
80104c39:	89 e5                	mov    %esp,%ebp
80104c3b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104c3e:	e8 f9 db ff ff       	call   8010283c <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104c43:	83 ec 08             	sub    $0x8,%esp
80104c46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c49:	50                   	push   %eax
80104c4a:	6a 00                	push   $0x0
80104c4c:	e8 c7 f7 ff ff       	call   80104418 <argstr>
80104c51:	83 c4 10             	add    $0x10,%esp
80104c54:	85 c0                	test   %eax,%eax
80104c56:	78 30                	js     80104c88 <sys_mkdir+0x50>
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	6a 00                	push   $0x0
80104c5d:	31 c9                	xor    %ecx,%ecx
80104c5f:	ba 01 00 00 00       	mov    $0x1,%edx
80104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c67:	e8 38 f8 ff ff       	call   801044a4 <create>
80104c6c:	83 c4 10             	add    $0x10,%esp
80104c6f:	85 c0                	test   %eax,%eax
80104c71:	74 15                	je     80104c88 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c73:	83 ec 0c             	sub    $0xc,%esp
80104c76:	50                   	push   %eax
80104c77:	e8 38 cb ff ff       	call   801017b4 <iunlockput>
  end_op();
80104c7c:	e8 23 dc ff ff       	call   801028a4 <end_op>
  return 0;
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	31 c0                	xor    %eax,%eax
}
80104c86:	c9                   	leave  
80104c87:	c3                   	ret    
    end_op();
80104c88:	e8 17 dc ff ff       	call   801028a4 <end_op>
    return -1;
80104c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    

80104c94 <sys_mknod>:

int
sys_mknod(void)
{
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104c9a:	e8 9d db ff ff       	call   8010283c <begin_op>
  if((argstr(0, &path)) < 0 ||
80104c9f:	83 ec 08             	sub    $0x8,%esp
80104ca2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ca5:	50                   	push   %eax
80104ca6:	6a 00                	push   $0x0
80104ca8:	e8 6b f7 ff ff       	call   80104418 <argstr>
80104cad:	83 c4 10             	add    $0x10,%esp
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 60                	js     80104d14 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cba:	50                   	push   %eax
80104cbb:	6a 01                	push   $0x1
80104cbd:	e8 be f6 ff ff       	call   80104380 <argint>
  if((argstr(0, &path)) < 0 ||
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	85 c0                	test   %eax,%eax
80104cc7:	78 4b                	js     80104d14 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104cc9:	83 ec 08             	sub    $0x8,%esp
80104ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ccf:	50                   	push   %eax
80104cd0:	6a 02                	push   $0x2
80104cd2:	e8 a9 f6 ff ff       	call   80104380 <argint>
     argint(1, &major) < 0 ||
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	78 36                	js     80104d14 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104cde:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104ce2:	83 ec 0c             	sub    $0xc,%esp
80104ce5:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104ce9:	50                   	push   %eax
80104cea:	ba 03 00 00 00       	mov    $0x3,%edx
80104cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cf2:	e8 ad f7 ff ff       	call   801044a4 <create>
     argint(2, &minor) < 0 ||
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	74 16                	je     80104d14 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104cfe:	83 ec 0c             	sub    $0xc,%esp
80104d01:	50                   	push   %eax
80104d02:	e8 ad ca ff ff       	call   801017b4 <iunlockput>
  end_op();
80104d07:	e8 98 db ff ff       	call   801028a4 <end_op>
  return 0;
80104d0c:	83 c4 10             	add    $0x10,%esp
80104d0f:	31 c0                	xor    %eax,%eax
}
80104d11:	c9                   	leave  
80104d12:	c3                   	ret    
80104d13:	90                   	nop
    end_op();
80104d14:	e8 8b db ff ff       	call   801028a4 <end_op>
    return -1;
80104d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d1e:	c9                   	leave  
80104d1f:	c3                   	ret    

80104d20 <sys_chdir>:

int
sys_chdir(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104d28:	e8 37 e6 ff ff       	call   80103364 <myproc>
80104d2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104d2f:	e8 08 db ff ff       	call   8010283c <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104d34:	83 ec 08             	sub    $0x8,%esp
80104d37:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3a:	50                   	push   %eax
80104d3b:	6a 00                	push   $0x0
80104d3d:	e8 d6 f6 ff ff       	call   80104418 <argstr>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	78 67                	js     80104db0 <sys_chdir+0x90>
80104d49:	83 ec 0c             	sub    $0xc,%esp
80104d4c:	ff 75 f4             	pushl  -0xc(%ebp)
80104d4f:	e8 bc cf ff ff       	call   80101d10 <namei>
80104d54:	89 c3                	mov    %eax,%ebx
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	74 53                	je     80104db0 <sys_chdir+0x90>
    end_op();
    return -1;
  }
  ilock(ip);
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	50                   	push   %eax
80104d61:	e8 f6 c7 ff ff       	call   8010155c <ilock>
  if(ip->type != T_DIR){
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d6e:	75 28                	jne    80104d98 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	53                   	push   %ebx
80104d74:	e8 ab c8 ff ff       	call   80101624 <iunlock>
  iput(curproc->cwd);
80104d79:	58                   	pop    %eax
80104d7a:	ff 76 70             	pushl  0x70(%esi)
80104d7d:	e8 e6 c8 ff ff       	call   80101668 <iput>
  end_op();
80104d82:	e8 1d db ff ff       	call   801028a4 <end_op>
  curproc->cwd = ip;
80104d87:	89 5e 70             	mov    %ebx,0x70(%esi)
  return 0;
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	31 c0                	xor    %eax,%eax
}
80104d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5d                   	pop    %ebp
80104d95:	c3                   	ret    
80104d96:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	53                   	push   %ebx
80104d9c:	e8 13 ca ff ff       	call   801017b4 <iunlockput>
    end_op();
80104da1:	e8 fe da ff ff       	call   801028a4 <end_op>
    return -1;
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dae:	eb df                	jmp    80104d8f <sys_chdir+0x6f>
    end_op();
80104db0:	e8 ef da ff ff       	call   801028a4 <end_op>
    return -1;
80104db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dba:	eb d3                	jmp    80104d8f <sys_chdir+0x6f>

80104dbc <sys_exec>:

int
sys_exec(void)
{
80104dbc:	55                   	push   %ebp
80104dbd:	89 e5                	mov    %esp,%ebp
80104dbf:	57                   	push   %edi
80104dc0:	56                   	push   %esi
80104dc1:	53                   	push   %ebx
80104dc2:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104dc8:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104dce:	50                   	push   %eax
80104dcf:	6a 00                	push   $0x0
80104dd1:	e8 42 f6 ff ff       	call   80104418 <argstr>
80104dd6:	83 c4 10             	add    $0x10,%esp
80104dd9:	85 c0                	test   %eax,%eax
80104ddb:	78 79                	js     80104e56 <sys_exec+0x9a>
80104ddd:	83 ec 08             	sub    $0x8,%esp
80104de0:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104de6:	50                   	push   %eax
80104de7:	6a 01                	push   $0x1
80104de9:	e8 92 f5 ff ff       	call   80104380 <argint>
80104dee:	83 c4 10             	add    $0x10,%esp
80104df1:	85 c0                	test   %eax,%eax
80104df3:	78 61                	js     80104e56 <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104df5:	50                   	push   %eax
80104df6:	68 80 00 00 00       	push   $0x80
80104dfb:	6a 00                	push   $0x0
80104dfd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80104e03:	57                   	push   %edi
80104e04:	e8 53 f3 ff ff       	call   8010415c <memset>
80104e09:	83 c4 10             	add    $0x10,%esp
80104e0c:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
80104e0e:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104e10:	83 ec 08             	sub    $0x8,%esp
80104e13:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104e19:	50                   	push   %eax
80104e1a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104e20:	01 d8                	add    %ebx,%eax
80104e22:	50                   	push   %eax
80104e23:	e8 ec f4 ff ff       	call   80104314 <fetchint>
80104e28:	83 c4 10             	add    $0x10,%esp
80104e2b:	85 c0                	test   %eax,%eax
80104e2d:	78 27                	js     80104e56 <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
80104e2f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104e35:	85 c0                	test   %eax,%eax
80104e37:	74 2b                	je     80104e64 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80104e3f:	52                   	push   %edx
80104e40:	50                   	push   %eax
80104e41:	e8 fe f4 ff ff       	call   80104344 <fetchstr>
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	78 09                	js     80104e56 <sys_exec+0x9a>
  for(i=0;; i++){
80104e4d:	46                   	inc    %esi
    if(i >= NELEM(argv))
80104e4e:	83 c3 04             	add    $0x4,%ebx
80104e51:	83 fe 20             	cmp    $0x20,%esi
80104e54:	75 ba                	jne    80104e10 <sys_exec+0x54>
    return -1;
80104e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e5e:	5b                   	pop    %ebx
80104e5f:	5e                   	pop    %esi
80104e60:	5f                   	pop    %edi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret    
80104e63:	90                   	nop
      argv[i] = 0;
80104e64:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
80104e6b:	00 00 00 00 
  return exec(path, argv);
80104e6f:	83 ec 08             	sub    $0x8,%esp
80104e72:	57                   	push   %edi
80104e73:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80104e79:	e8 26 bb ff ff       	call   801009a4 <exec>
80104e7e:	83 c4 10             	add    $0x10,%esp
}
80104e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e84:	5b                   	pop    %ebx
80104e85:	5e                   	pop    %esi
80104e86:	5f                   	pop    %edi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d 76 00             	lea    0x0(%esi),%esi

80104e8c <sys_pipe>:

int
sys_pipe(void)
{
80104e8c:	55                   	push   %ebp
80104e8d:	89 e5                	mov    %esp,%ebp
80104e8f:	57                   	push   %edi
80104e90:	56                   	push   %esi
80104e91:	53                   	push   %ebx
80104e92:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104e95:	6a 08                	push   $0x8
80104e97:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104e9a:	50                   	push   %eax
80104e9b:	6a 00                	push   $0x0
80104e9d:	e8 22 f5 ff ff       	call   801043c4 <argptr>
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 48                	js     80104ef1 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104ea9:	83 ec 08             	sub    $0x8,%esp
80104eac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104eaf:	50                   	push   %eax
80104eb0:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104eb3:	50                   	push   %eax
80104eb4:	e8 7b df ff ff       	call   80102e34 <pipealloc>
80104eb9:	83 c4 10             	add    $0x10,%esp
80104ebc:	85 c0                	test   %eax,%eax
80104ebe:	78 31                	js     80104ef1 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104ec0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80104ec3:	e8 9c e4 ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ec8:	31 db                	xor    %ebx,%ebx
80104eca:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ecc:	8b 74 98 30          	mov    0x30(%eax,%ebx,4),%esi
80104ed0:	85 f6                	test   %esi,%esi
80104ed2:	74 24                	je     80104ef8 <sys_pipe+0x6c>
  for(fd = 0; fd < NOFILE; fd++){
80104ed4:	43                   	inc    %ebx
80104ed5:	83 fb 10             	cmp    $0x10,%ebx
80104ed8:	75 f2                	jne    80104ecc <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80104eda:	83 ec 0c             	sub    $0xc,%esp
80104edd:	ff 75 e0             	pushl  -0x20(%ebp)
80104ee0:	e8 b7 be ff ff       	call   80100d9c <fileclose>
    fileclose(wf);
80104ee5:	58                   	pop    %eax
80104ee6:	ff 75 e4             	pushl  -0x1c(%ebp)
80104ee9:	e8 ae be ff ff       	call   80100d9c <fileclose>
    return -1;
80104eee:	83 c4 10             	add    $0x10,%esp
80104ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef6:	eb 3d                	jmp    80104f35 <sys_pipe+0xa9>
      curproc->ofile[fd] = f;
80104ef8:	8d 73 0c             	lea    0xc(%ebx),%esi
80104efb:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104efe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80104f01:	e8 5e e4 ff ff       	call   80103364 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f06:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104f08:	8b 4c 90 30          	mov    0x30(%eax,%edx,4),%ecx
80104f0c:	85 c9                	test   %ecx,%ecx
80104f0e:	74 14                	je     80104f24 <sys_pipe+0x98>
  for(fd = 0; fd < NOFILE; fd++){
80104f10:	42                   	inc    %edx
80104f11:	83 fa 10             	cmp    $0x10,%edx
80104f14:	75 f2                	jne    80104f08 <sys_pipe+0x7c>
      myproc()->ofile[fd0] = 0;
80104f16:	e8 49 e4 ff ff       	call   80103364 <myproc>
80104f1b:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
80104f22:	eb b6                	jmp    80104eda <sys_pipe+0x4e>
      curproc->ofile[fd] = f;
80104f24:	89 7c 90 30          	mov    %edi,0x30(%eax,%edx,4)
  }
  fd[0] = fd0;
80104f28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f2b:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80104f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f30:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f38:	5b                   	pop    %ebx
80104f39:	5e                   	pop    %esi
80104f3a:	5f                   	pop    %edi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	66 90                	xchg   %ax,%ax
80104f3f:	90                   	nop

80104f40 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int sys_fork(void)
{
  return fork();
80104f40:	e9 97 e5 ff ff       	jmp    801034dc <fork>
80104f45:	8d 76 00             	lea    0x0(%esi),%esi

80104f48 <sys_exit>:
}

int sys_exit(void)
{
80104f48:	55                   	push   %ebp
80104f49:	89 e5                	mov    %esp,%ebp
80104f4b:	83 ec 08             	sub    $0x8,%esp
  exit();
80104f4e:	e8 51 e9 ff ff       	call   801038a4 <exit>
  return 0; // not reached
}
80104f53:	31 c0                	xor    %eax,%eax
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	90                   	nop

80104f58 <sys_wait>:

int sys_wait(void)
{
  return wait();
80104f58:	e9 73 eb ff ff       	jmp    80103ad0 <wait>
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi

80104f60 <sys_kill>:
}

int sys_kill(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80104f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f69:	50                   	push   %eax
80104f6a:	6a 00                	push   $0x0
80104f6c:	e8 0f f4 ff ff       	call   80104380 <argint>
80104f71:	83 c4 10             	add    $0x10,%esp
80104f74:	85 c0                	test   %eax,%eax
80104f76:	78 10                	js     80104f88 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104f78:	83 ec 0c             	sub    $0xc,%esp
80104f7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f7e:	e8 a1 ec ff ff       	call   80103c24 <kill>
80104f83:	83 c4 10             	add    $0x10,%esp
}
80104f86:	c9                   	leave  
80104f87:	c3                   	ret    
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f8d:	c9                   	leave  
80104f8e:	c3                   	ret    
80104f8f:	90                   	nop

80104f90 <sys_getpid>:

int sys_getpid(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104f96:	e8 c9 e3 ff ff       	call   80103364 <myproc>
80104f9b:	8b 40 18             	mov    0x18(%eax),%eax
}
80104f9e:	c9                   	leave  
80104f9f:	c3                   	ret    

80104fa0 <sys_sbrk>:

int sys_sbrk(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80104fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104faa:	50                   	push   %eax
80104fab:	6a 00                	push   $0x0
80104fad:	e8 ce f3 ff ff       	call   80104380 <argint>
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	78 23                	js     80104fdc <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80104fb9:	e8 a6 e3 ff ff       	call   80103364 <myproc>
80104fbe:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc6:	e8 a1 e4 ff ff       	call   8010346c <growproc>
80104fcb:	83 c4 10             	add    $0x10,%esp
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	78 0a                	js     80104fdc <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80104fd2:	89 d8                	mov    %ebx,%eax
80104fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd7:	c9                   	leave  
80104fd8:	c3                   	ret    
80104fd9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fdc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fe1:	eb ef                	jmp    80104fd2 <sys_sbrk+0x32>
80104fe3:	90                   	nop

80104fe4 <sys_sleep>:

int sys_sleep(void)
{
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	53                   	push   %ebx
80104fe8:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80104feb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fee:	50                   	push   %eax
80104fef:	6a 00                	push   $0x0
80104ff1:	e8 8a f3 ff ff       	call   80104380 <argint>
80104ff6:	83 c4 10             	add    $0x10,%esp
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	78 7e                	js     8010507b <sys_sleep+0x97>
    return -1;
  acquire(&tickslock);
80104ffd:	83 ec 0c             	sub    $0xc,%esp
80105000:	68 60 4e 11 80       	push   $0x80114e60
80105005:	e8 72 f0 ff ff       	call   8010407c <acquire>
  ticks0 = ticks;
8010500a:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  while (ticks - ticks0 < n)
80105010:	83 c4 10             	add    $0x10,%esp
80105013:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105016:	85 d2                	test   %edx,%edx
80105018:	75 23                	jne    8010503d <sys_sleep+0x59>
8010501a:	eb 48                	jmp    80105064 <sys_sleep+0x80>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
8010501c:	83 ec 08             	sub    $0x8,%esp
8010501f:	68 60 4e 11 80       	push   $0x80114e60
80105024:	68 a0 56 11 80       	push   $0x801156a0
80105029:	e8 e6 e9 ff ff       	call   80103a14 <sleep>
  while (ticks - ticks0 < n)
8010502e:	a1 a0 56 11 80       	mov    0x801156a0,%eax
80105033:	29 d8                	sub    %ebx,%eax
80105035:	83 c4 10             	add    $0x10,%esp
80105038:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010503b:	73 27                	jae    80105064 <sys_sleep+0x80>
    if (myproc()->killed)
8010503d:	e8 22 e3 ff ff       	call   80103364 <myproc>
80105042:	8b 40 2c             	mov    0x2c(%eax),%eax
80105045:	85 c0                	test   %eax,%eax
80105047:	74 d3                	je     8010501c <sys_sleep+0x38>
      release(&tickslock);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	68 60 4e 11 80       	push   $0x80114e60
80105051:	e8 be f0 ff ff       	call   80104114 <release>
      return -1;
80105056:	83 c4 10             	add    $0x10,%esp
80105059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010505e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105061:	c9                   	leave  
80105062:	c3                   	ret    
80105063:	90                   	nop
  release(&tickslock);
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	68 60 4e 11 80       	push   $0x80114e60
8010506c:	e8 a3 f0 ff ff       	call   80104114 <release>
  return 0;
80105071:	83 c4 10             	add    $0x10,%esp
80105074:	31 c0                	xor    %eax,%eax
}
80105076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105079:	c9                   	leave  
8010507a:	c3                   	ret    
    return -1;
8010507b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105080:	eb f4                	jmp    80105076 <sys_sleep+0x92>
80105082:	66 90                	xchg   %ax,%ax

80105084 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	83 ec 24             	sub    $0x24,%esp
  uint xticks;

  acquire(&tickslock);
8010508a:	68 60 4e 11 80       	push   $0x80114e60
8010508f:	e8 e8 ef ff ff       	call   8010407c <acquire>
  xticks = ticks;
80105094:	a1 a0 56 11 80       	mov    0x801156a0,%eax
80105099:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010509c:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801050a3:	e8 6c f0 ff ff       	call   80104114 <release>
  return xticks;
}
801050a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ab:	c9                   	leave  
801050ac:	c3                   	ret    
801050ad:	8d 76 00             	lea    0x0(%esi),%esi

801050b0 <sys_settickets>:

// set tickets.
int sys_settickets(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 20             	sub    $0x20,%esp
  int tickets;

  if (argint(0, &tickets) < 0)
801050b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b9:	50                   	push   %eax
801050ba:	6a 00                	push   $0x0
801050bc:	e8 bf f2 ff ff       	call   80104380 <argint>
801050c1:	83 c4 10             	add    $0x10,%esp
801050c4:	85 c0                	test   %eax,%eax
801050c6:	78 18                	js     801050e0 <sys_settickets+0x30>
    return -1;

  if (tickets < 1)
801050c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050cb:	85 c0                	test   %eax,%eax
801050cd:	7e 11                	jle    801050e0 <sys_settickets+0x30>
    return -1;

  return settickets(tickets);
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	50                   	push   %eax
801050d3:	e8 70 ec ff ff       	call   80103d48 <settickets>
801050d8:	83 c4 10             	add    $0x10,%esp
}
801050db:	c9                   	leave  
801050dc:	c3                   	ret    
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	90                   	nop

801050e8 <sys_getpinfo>:

// get proc info
int sys_getpinfo(void)
{
801050e8:	55                   	push   %ebp
801050e9:	89 e5                	mov    %esp,%ebp
801050eb:	83 ec 1c             	sub    $0x1c,%esp
  struct pstat *p;

  if (argptr(0, (void *)&p, sizeof(*p)) < 0)
801050ee:	68 00 04 00 00       	push   $0x400
801050f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050f6:	50                   	push   %eax
801050f7:	6a 00                	push   $0x0
801050f9:	e8 c6 f2 ff ff       	call   801043c4 <argptr>
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	85 c0                	test   %eax,%eax
80105103:	78 13                	js     80105118 <sys_getpinfo+0x30>
    return -1;

  return getpinfo(p);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	ff 75 f4             	pushl  -0xc(%ebp)
8010510b:	e8 b8 ec ff ff       	call   80103dc8 <getpinfo>
80105110:	83 c4 10             	add    $0x10,%esp
}
80105113:	c9                   	leave  
80105114:	c3                   	ret    
80105115:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010511d:	c9                   	leave  
8010511e:	c3                   	ret    

8010511f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010511f:	1e                   	push   %ds
  pushl %es
80105120:	06                   	push   %es
  pushl %fs
80105121:	0f a0                	push   %fs
  pushl %gs
80105123:	0f a8                	push   %gs
  pushal
80105125:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105126:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010512a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010512c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010512e:	54                   	push   %esp
  call trap
8010512f:	e8 a0 00 00 00       	call   801051d4 <trap>
  addl $4, %esp
80105134:	83 c4 04             	add    $0x4,%esp

80105137 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105137:	61                   	popa   
  popl %gs
80105138:	0f a9                	pop    %gs
  popl %fs
8010513a:	0f a1                	pop    %fs
  popl %es
8010513c:	07                   	pop    %es
  popl %ds
8010513d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010513e:	83 c4 08             	add    $0x8,%esp
  iret
80105141:	cf                   	iret   
80105142:	66 90                	xchg   %ax,%ax

80105144 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010514a:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010514c:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105153:	66 89 14 c5 a0 4e 11 	mov    %dx,-0x7feeb160(,%eax,8)
8010515a:	80 
8010515b:	c7 04 c5 a2 4e 11 80 	movl   $0x8e000008,-0x7feeb15e(,%eax,8)
80105162:	08 00 00 8e 
80105166:	c1 ea 10             	shr    $0x10,%edx
80105169:	66 89 14 c5 a6 4e 11 	mov    %dx,-0x7feeb15a(,%eax,8)
80105170:	80 
  for(i = 0; i < 256; i++)
80105171:	40                   	inc    %eax
80105172:	3d 00 01 00 00       	cmp    $0x100,%eax
80105177:	75 d3                	jne    8010514c <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105179:	a1 0c a1 10 80       	mov    0x8010a10c,%eax
8010517e:	66 a3 a0 50 11 80    	mov    %ax,0x801150a0
80105184:	c7 05 a2 50 11 80 08 	movl   $0xef000008,0x801150a2
8010518b:	00 00 ef 
8010518e:	c1 e8 10             	shr    $0x10,%eax
80105191:	66 a3 a6 50 11 80    	mov    %ax,0x801150a6

  initlock(&tickslock, "time");
80105197:	83 ec 08             	sub    $0x8,%esp
8010519a:	68 01 70 10 80       	push   $0x80107001
8010519f:	68 60 4e 11 80       	push   $0x80114e60
801051a4:	e8 93 ed ff ff       	call   80103f3c <initlock>
}
801051a9:	83 c4 10             	add    $0x10,%esp
801051ac:	c9                   	leave  
801051ad:	c3                   	ret    
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <idtinit>:

void
idtinit(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801051b6:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801051bc:	b8 a0 4e 11 80       	mov    $0x80114ea0,%eax
801051c1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801051c5:	c1 e8 10             	shr    $0x10,%eax
801051c8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801051cc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801051cf:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801051d2:	c9                   	leave  
801051d3:	c3                   	ret    

801051d4 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	57                   	push   %edi
801051d8:	56                   	push   %esi
801051d9:	53                   	push   %ebx
801051da:	83 ec 1c             	sub    $0x1c,%esp
801051dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801051e0:	8b 43 30             	mov    0x30(%ebx),%eax
801051e3:	83 f8 40             	cmp    $0x40,%eax
801051e6:	0f 84 b4 01 00 00    	je     801053a0 <trap+0x1cc>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801051ec:	83 e8 20             	sub    $0x20,%eax
801051ef:	83 f8 1f             	cmp    $0x1f,%eax
801051f2:	77 07                	ja     801051fb <trap+0x27>
801051f4:	ff 24 85 a8 70 10 80 	jmp    *-0x7fef8f58(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801051fb:	e8 64 e1 ff ff       	call   80103364 <myproc>
80105200:	8b 7b 38             	mov    0x38(%ebx),%edi
80105203:	85 c0                	test   %eax,%eax
80105205:	0f 84 e0 01 00 00    	je     801053eb <trap+0x217>
8010520b:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010520f:	0f 84 d6 01 00 00    	je     801053eb <trap+0x217>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105215:	0f 20 d1             	mov    %cr2,%ecx
80105218:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010521b:	e8 10 e1 ff ff       	call   80103330 <cpuid>
80105220:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105223:	8b 43 34             	mov    0x34(%ebx),%eax
80105226:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105229:	8b 73 30             	mov    0x30(%ebx),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010522c:	e8 33 e1 ff ff       	call   80103364 <myproc>
80105231:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105234:	e8 2b e1 ff ff       	call   80103364 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105239:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010523c:	51                   	push   %ecx
8010523d:	57                   	push   %edi
8010523e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105241:	52                   	push   %edx
80105242:	ff 75 e4             	pushl  -0x1c(%ebp)
80105245:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105246:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105249:	83 c6 74             	add    $0x74,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010524c:	56                   	push   %esi
8010524d:	ff 70 18             	pushl  0x18(%eax)
80105250:	68 64 70 10 80       	push   $0x80107064
80105255:	e8 c6 b3 ff ff       	call   80100620 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010525a:	83 c4 20             	add    $0x20,%esp
8010525d:	e8 02 e1 ff ff       	call   80103364 <myproc>
80105262:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105269:	e8 f6 e0 ff ff       	call   80103364 <myproc>
8010526e:	85 c0                	test   %eax,%eax
80105270:	74 1c                	je     8010528e <trap+0xba>
80105272:	e8 ed e0 ff ff       	call   80103364 <myproc>
80105277:	8b 50 2c             	mov    0x2c(%eax),%edx
8010527a:	85 d2                	test   %edx,%edx
8010527c:	74 10                	je     8010528e <trap+0xba>
8010527e:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105281:	83 e0 03             	and    $0x3,%eax
80105284:	66 83 f8 03          	cmp    $0x3,%ax
80105288:	0f 84 4a 01 00 00    	je     801053d8 <trap+0x204>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010528e:	e8 d1 e0 ff ff       	call   80103364 <myproc>
80105293:	85 c0                	test   %eax,%eax
80105295:	74 0f                	je     801052a6 <trap+0xd2>
80105297:	e8 c8 e0 ff ff       	call   80103364 <myproc>
8010529c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801052a0:	0f 84 e6 00 00 00    	je     8010538c <trap+0x1b8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052a6:	e8 b9 e0 ff ff       	call   80103364 <myproc>
801052ab:	85 c0                	test   %eax,%eax
801052ad:	74 1c                	je     801052cb <trap+0xf7>
801052af:	e8 b0 e0 ff ff       	call   80103364 <myproc>
801052b4:	8b 40 2c             	mov    0x2c(%eax),%eax
801052b7:	85 c0                	test   %eax,%eax
801052b9:	74 10                	je     801052cb <trap+0xf7>
801052bb:	8b 43 3c             	mov    0x3c(%ebx),%eax
801052be:	83 e0 03             	and    $0x3,%eax
801052c1:	66 83 f8 03          	cmp    $0x3,%ax
801052c5:	0f 84 fe 00 00 00    	je     801053c9 <trap+0x1f5>
    exit();
}
801052cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ce:	5b                   	pop    %ebx
801052cf:	5e                   	pop    %esi
801052d0:	5f                   	pop    %edi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
    ideintr();
801052d3:	e8 84 cb ff ff       	call   80101e5c <ideintr>
    lapiceoi();
801052d8:	e8 93 d1 ff ff       	call   80102470 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052dd:	e8 82 e0 ff ff       	call   80103364 <myproc>
801052e2:	85 c0                	test   %eax,%eax
801052e4:	75 8c                	jne    80105272 <trap+0x9e>
801052e6:	eb a6                	jmp    8010528e <trap+0xba>
    if(cpuid() == 0){
801052e8:	e8 43 e0 ff ff       	call   80103330 <cpuid>
801052ed:	85 c0                	test   %eax,%eax
801052ef:	75 e7                	jne    801052d8 <trap+0x104>
      acquire(&tickslock);
801052f1:	83 ec 0c             	sub    $0xc,%esp
801052f4:	68 60 4e 11 80       	push   $0x80114e60
801052f9:	e8 7e ed ff ff       	call   8010407c <acquire>
      ticks++;
801052fe:	ff 05 a0 56 11 80    	incl   0x801156a0
      wakeup(&ticks);
80105304:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
8010530b:	e8 b8 e8 ff ff       	call   80103bc8 <wakeup>
      release(&tickslock);
80105310:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80105317:	e8 f8 ed ff ff       	call   80104114 <release>
8010531c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010531f:	eb b7                	jmp    801052d8 <trap+0x104>
    kbdintr();
80105321:	e8 3a d0 ff ff       	call   80102360 <kbdintr>
    lapiceoi();
80105326:	e8 45 d1 ff ff       	call   80102470 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010532b:	e8 34 e0 ff ff       	call   80103364 <myproc>
80105330:	85 c0                	test   %eax,%eax
80105332:	0f 85 3a ff ff ff    	jne    80105272 <trap+0x9e>
80105338:	e9 51 ff ff ff       	jmp    8010528e <trap+0xba>
    uartintr();
8010533d:	e8 fa 01 00 00       	call   8010553c <uartintr>
    lapiceoi();
80105342:	e8 29 d1 ff ff       	call   80102470 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105347:	e8 18 e0 ff ff       	call   80103364 <myproc>
8010534c:	85 c0                	test   %eax,%eax
8010534e:	0f 85 1e ff ff ff    	jne    80105272 <trap+0x9e>
80105354:	e9 35 ff ff ff       	jmp    8010528e <trap+0xba>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105359:	8b 7b 38             	mov    0x38(%ebx),%edi
8010535c:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105360:	e8 cb df ff ff       	call   80103330 <cpuid>
80105365:	57                   	push   %edi
80105366:	56                   	push   %esi
80105367:	50                   	push   %eax
80105368:	68 0c 70 10 80       	push   $0x8010700c
8010536d:	e8 ae b2 ff ff       	call   80100620 <cprintf>
    lapiceoi();
80105372:	e8 f9 d0 ff ff       	call   80102470 <lapiceoi>
    break;
80105377:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010537a:	e8 e5 df ff ff       	call   80103364 <myproc>
8010537f:	85 c0                	test   %eax,%eax
80105381:	0f 85 eb fe ff ff    	jne    80105272 <trap+0x9e>
80105387:	e9 02 ff ff ff       	jmp    8010528e <trap+0xba>
  if(myproc() && myproc()->state == RUNNING &&
8010538c:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105390:	0f 85 10 ff ff ff    	jne    801052a6 <trap+0xd2>
    yield();
80105396:	e8 31 e6 ff ff       	call   801039cc <yield>
8010539b:	e9 06 ff ff ff       	jmp    801052a6 <trap+0xd2>
    if(myproc()->killed)
801053a0:	e8 bf df ff ff       	call   80103364 <myproc>
801053a5:	8b 70 2c             	mov    0x2c(%eax),%esi
801053a8:	85 f6                	test   %esi,%esi
801053aa:	75 38                	jne    801053e4 <trap+0x210>
    myproc()->tf = tf;
801053ac:	e8 b3 df ff ff       	call   80103364 <myproc>
801053b1:	89 58 20             	mov    %ebx,0x20(%eax)
    syscall();
801053b4:	e8 93 f0 ff ff       	call   8010444c <syscall>
    if(myproc()->killed)
801053b9:	e8 a6 df ff ff       	call   80103364 <myproc>
801053be:	8b 48 2c             	mov    0x2c(%eax),%ecx
801053c1:	85 c9                	test   %ecx,%ecx
801053c3:	0f 84 02 ff ff ff    	je     801052cb <trap+0xf7>
}
801053c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053cc:	5b                   	pop    %ebx
801053cd:	5e                   	pop    %esi
801053ce:	5f                   	pop    %edi
801053cf:	5d                   	pop    %ebp
      exit();
801053d0:	e9 cf e4 ff ff       	jmp    801038a4 <exit>
801053d5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801053d8:	e8 c7 e4 ff ff       	call   801038a4 <exit>
801053dd:	e9 ac fe ff ff       	jmp    8010528e <trap+0xba>
801053e2:	66 90                	xchg   %ax,%ax
      exit();
801053e4:	e8 bb e4 ff ff       	call   801038a4 <exit>
801053e9:	eb c1                	jmp    801053ac <trap+0x1d8>
801053eb:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801053ee:	e8 3d df ff ff       	call   80103330 <cpuid>
801053f3:	83 ec 0c             	sub    $0xc,%esp
801053f6:	56                   	push   %esi
801053f7:	57                   	push   %edi
801053f8:	50                   	push   %eax
801053f9:	ff 73 30             	pushl  0x30(%ebx)
801053fc:	68 30 70 10 80       	push   $0x80107030
80105401:	e8 1a b2 ff ff       	call   80100620 <cprintf>
      panic("trap");
80105406:	83 c4 14             	add    $0x14,%esp
80105409:	68 06 70 10 80       	push   $0x80107006
8010540e:	e8 2d af ff ff       	call   80100340 <panic>
80105413:	90                   	nop

80105414 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105414:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105419:	85 c0                	test   %eax,%eax
8010541b:	74 17                	je     80105434 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010541d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105422:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105423:	a8 01                	test   $0x1,%al
80105425:	74 0d                	je     80105434 <uartgetc+0x20>
80105427:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010542c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010542d:	0f b6 c0             	movzbl %al,%eax
80105430:	c3                   	ret    
80105431:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105439:	c3                   	ret    
8010543a:	66 90                	xchg   %ax,%ax

8010543c <uartputc.part.0>:
uartputc(int c)
8010543c:	55                   	push   %ebp
8010543d:	89 e5                	mov    %esp,%ebp
8010543f:	57                   	push   %edi
80105440:	56                   	push   %esi
80105441:	53                   	push   %ebx
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	89 c7                	mov    %eax,%edi
80105447:	bb 80 00 00 00       	mov    $0x80,%ebx
8010544c:	be fd 03 00 00       	mov    $0x3fd,%esi
80105451:	eb 11                	jmp    80105464 <uartputc.part.0+0x28>
80105453:	90                   	nop
    microdelay(10);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	6a 0a                	push   $0xa
80105459:	e8 2a d0 ff ff       	call   80102488 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	4b                   	dec    %ebx
80105462:	74 07                	je     8010546b <uartputc.part.0+0x2f>
80105464:	89 f2                	mov    %esi,%edx
80105466:	ec                   	in     (%dx),%al
80105467:	a8 20                	test   $0x20,%al
80105469:	74 e9                	je     80105454 <uartputc.part.0+0x18>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010546b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105470:	89 f8                	mov    %edi,%eax
80105472:	ee                   	out    %al,(%dx)
}
80105473:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105476:	5b                   	pop    %ebx
80105477:	5e                   	pop    %esi
80105478:	5f                   	pop    %edi
80105479:	5d                   	pop    %ebp
8010547a:	c3                   	ret    
8010547b:	90                   	nop

8010547c <uartinit>:
{
8010547c:	55                   	push   %ebp
8010547d:	89 e5                	mov    %esp,%ebp
8010547f:	57                   	push   %edi
80105480:	56                   	push   %esi
80105481:	53                   	push   %ebx
80105482:	83 ec 1c             	sub    $0x1c,%esp
80105485:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010548a:	31 c0                	xor    %eax,%eax
8010548c:	89 da                	mov    %ebx,%edx
8010548e:	ee                   	out    %al,(%dx)
8010548f:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105494:	b0 80                	mov    $0x80,%al
80105496:	89 fa                	mov    %edi,%edx
80105498:	ee                   	out    %al,(%dx)
80105499:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
8010549e:	b0 0c                	mov    $0xc,%al
801054a0:	89 ca                	mov    %ecx,%edx
801054a2:	ee                   	out    %al,(%dx)
801054a3:	be f9 03 00 00       	mov    $0x3f9,%esi
801054a8:	31 c0                	xor    %eax,%eax
801054aa:	89 f2                	mov    %esi,%edx
801054ac:	ee                   	out    %al,(%dx)
801054ad:	b0 03                	mov    $0x3,%al
801054af:	89 fa                	mov    %edi,%edx
801054b1:	ee                   	out    %al,(%dx)
801054b2:	ba fc 03 00 00       	mov    $0x3fc,%edx
801054b7:	31 c0                	xor    %eax,%eax
801054b9:	ee                   	out    %al,(%dx)
801054ba:	b0 01                	mov    $0x1,%al
801054bc:	89 f2                	mov    %esi,%edx
801054be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801054bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801054c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801054c5:	fe c0                	inc    %al
801054c7:	74 4f                	je     80105518 <uartinit+0x9c>
  uart = 1;
801054c9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801054d0:	00 00 00 
801054d3:	89 da                	mov    %ebx,%edx
801054d5:	ec                   	in     (%dx),%al
801054d6:	89 ca                	mov    %ecx,%edx
801054d8:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801054d9:	83 ec 08             	sub    $0x8,%esp
801054dc:	6a 00                	push   $0x0
801054de:	6a 04                	push   $0x4
801054e0:	e8 8b cb ff ff       	call   80102070 <ioapicenable>
801054e5:	83 c4 10             	add    $0x10,%esp
801054e8:	b2 76                	mov    $0x76,%dl
  for(p="xv6...\n"; *p; p++)
801054ea:	bb 28 71 10 80       	mov    $0x80107128,%ebx
801054ef:	b8 78 00 00 00       	mov    $0x78,%eax
801054f4:	eb 08                	jmp    801054fe <uartinit+0x82>
801054f6:	66 90                	xchg   %ax,%ax
801054f8:	0f be c2             	movsbl %dl,%eax
801054fb:	8a 53 01             	mov    0x1(%ebx),%dl
  if(!uart)
801054fe:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
80105504:	85 c9                	test   %ecx,%ecx
80105506:	74 0b                	je     80105513 <uartinit+0x97>
80105508:	88 55 e7             	mov    %dl,-0x19(%ebp)
8010550b:	e8 2c ff ff ff       	call   8010543c <uartputc.part.0>
80105510:	8a 55 e7             	mov    -0x19(%ebp),%dl
  for(p="xv6...\n"; *p; p++)
80105513:	43                   	inc    %ebx
80105514:	84 d2                	test   %dl,%dl
80105516:	75 e0                	jne    801054f8 <uartinit+0x7c>
}
80105518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010551b:	5b                   	pop    %ebx
8010551c:	5e                   	pop    %esi
8010551d:	5f                   	pop    %edi
8010551e:	5d                   	pop    %ebp
8010551f:	c3                   	ret    

80105520 <uartputc>:
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105526:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
8010552c:	85 d2                	test   %edx,%edx
8010552e:	74 08                	je     80105538 <uartputc+0x18>
}
80105530:	5d                   	pop    %ebp
80105531:	e9 06 ff ff ff       	jmp    8010543c <uartputc.part.0>
80105536:	66 90                	xchg   %ax,%ax
80105538:	5d                   	pop    %ebp
80105539:	c3                   	ret    
8010553a:	66 90                	xchg   %ax,%ax

8010553c <uartintr>:

void
uartintr(void)
{
8010553c:	55                   	push   %ebp
8010553d:	89 e5                	mov    %esp,%ebp
8010553f:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105542:	68 14 54 10 80       	push   $0x80105414
80105547:	e8 5c b2 ff ff       	call   801007a8 <consoleintr>
}
8010554c:	83 c4 10             	add    $0x10,%esp
8010554f:	c9                   	leave  
80105550:	c3                   	ret    

80105551 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105551:	6a 00                	push   $0x0
  pushl $0
80105553:	6a 00                	push   $0x0
  jmp alltraps
80105555:	e9 c5 fb ff ff       	jmp    8010511f <alltraps>

8010555a <vector1>:
.globl vector1
vector1:
  pushl $0
8010555a:	6a 00                	push   $0x0
  pushl $1
8010555c:	6a 01                	push   $0x1
  jmp alltraps
8010555e:	e9 bc fb ff ff       	jmp    8010511f <alltraps>

80105563 <vector2>:
.globl vector2
vector2:
  pushl $0
80105563:	6a 00                	push   $0x0
  pushl $2
80105565:	6a 02                	push   $0x2
  jmp alltraps
80105567:	e9 b3 fb ff ff       	jmp    8010511f <alltraps>

8010556c <vector3>:
.globl vector3
vector3:
  pushl $0
8010556c:	6a 00                	push   $0x0
  pushl $3
8010556e:	6a 03                	push   $0x3
  jmp alltraps
80105570:	e9 aa fb ff ff       	jmp    8010511f <alltraps>

80105575 <vector4>:
.globl vector4
vector4:
  pushl $0
80105575:	6a 00                	push   $0x0
  pushl $4
80105577:	6a 04                	push   $0x4
  jmp alltraps
80105579:	e9 a1 fb ff ff       	jmp    8010511f <alltraps>

8010557e <vector5>:
.globl vector5
vector5:
  pushl $0
8010557e:	6a 00                	push   $0x0
  pushl $5
80105580:	6a 05                	push   $0x5
  jmp alltraps
80105582:	e9 98 fb ff ff       	jmp    8010511f <alltraps>

80105587 <vector6>:
.globl vector6
vector6:
  pushl $0
80105587:	6a 00                	push   $0x0
  pushl $6
80105589:	6a 06                	push   $0x6
  jmp alltraps
8010558b:	e9 8f fb ff ff       	jmp    8010511f <alltraps>

80105590 <vector7>:
.globl vector7
vector7:
  pushl $0
80105590:	6a 00                	push   $0x0
  pushl $7
80105592:	6a 07                	push   $0x7
  jmp alltraps
80105594:	e9 86 fb ff ff       	jmp    8010511f <alltraps>

80105599 <vector8>:
.globl vector8
vector8:
  pushl $8
80105599:	6a 08                	push   $0x8
  jmp alltraps
8010559b:	e9 7f fb ff ff       	jmp    8010511f <alltraps>

801055a0 <vector9>:
.globl vector9
vector9:
  pushl $0
801055a0:	6a 00                	push   $0x0
  pushl $9
801055a2:	6a 09                	push   $0x9
  jmp alltraps
801055a4:	e9 76 fb ff ff       	jmp    8010511f <alltraps>

801055a9 <vector10>:
.globl vector10
vector10:
  pushl $10
801055a9:	6a 0a                	push   $0xa
  jmp alltraps
801055ab:	e9 6f fb ff ff       	jmp    8010511f <alltraps>

801055b0 <vector11>:
.globl vector11
vector11:
  pushl $11
801055b0:	6a 0b                	push   $0xb
  jmp alltraps
801055b2:	e9 68 fb ff ff       	jmp    8010511f <alltraps>

801055b7 <vector12>:
.globl vector12
vector12:
  pushl $12
801055b7:	6a 0c                	push   $0xc
  jmp alltraps
801055b9:	e9 61 fb ff ff       	jmp    8010511f <alltraps>

801055be <vector13>:
.globl vector13
vector13:
  pushl $13
801055be:	6a 0d                	push   $0xd
  jmp alltraps
801055c0:	e9 5a fb ff ff       	jmp    8010511f <alltraps>

801055c5 <vector14>:
.globl vector14
vector14:
  pushl $14
801055c5:	6a 0e                	push   $0xe
  jmp alltraps
801055c7:	e9 53 fb ff ff       	jmp    8010511f <alltraps>

801055cc <vector15>:
.globl vector15
vector15:
  pushl $0
801055cc:	6a 00                	push   $0x0
  pushl $15
801055ce:	6a 0f                	push   $0xf
  jmp alltraps
801055d0:	e9 4a fb ff ff       	jmp    8010511f <alltraps>

801055d5 <vector16>:
.globl vector16
vector16:
  pushl $0
801055d5:	6a 00                	push   $0x0
  pushl $16
801055d7:	6a 10                	push   $0x10
  jmp alltraps
801055d9:	e9 41 fb ff ff       	jmp    8010511f <alltraps>

801055de <vector17>:
.globl vector17
vector17:
  pushl $17
801055de:	6a 11                	push   $0x11
  jmp alltraps
801055e0:	e9 3a fb ff ff       	jmp    8010511f <alltraps>

801055e5 <vector18>:
.globl vector18
vector18:
  pushl $0
801055e5:	6a 00                	push   $0x0
  pushl $18
801055e7:	6a 12                	push   $0x12
  jmp alltraps
801055e9:	e9 31 fb ff ff       	jmp    8010511f <alltraps>

801055ee <vector19>:
.globl vector19
vector19:
  pushl $0
801055ee:	6a 00                	push   $0x0
  pushl $19
801055f0:	6a 13                	push   $0x13
  jmp alltraps
801055f2:	e9 28 fb ff ff       	jmp    8010511f <alltraps>

801055f7 <vector20>:
.globl vector20
vector20:
  pushl $0
801055f7:	6a 00                	push   $0x0
  pushl $20
801055f9:	6a 14                	push   $0x14
  jmp alltraps
801055fb:	e9 1f fb ff ff       	jmp    8010511f <alltraps>

80105600 <vector21>:
.globl vector21
vector21:
  pushl $0
80105600:	6a 00                	push   $0x0
  pushl $21
80105602:	6a 15                	push   $0x15
  jmp alltraps
80105604:	e9 16 fb ff ff       	jmp    8010511f <alltraps>

80105609 <vector22>:
.globl vector22
vector22:
  pushl $0
80105609:	6a 00                	push   $0x0
  pushl $22
8010560b:	6a 16                	push   $0x16
  jmp alltraps
8010560d:	e9 0d fb ff ff       	jmp    8010511f <alltraps>

80105612 <vector23>:
.globl vector23
vector23:
  pushl $0
80105612:	6a 00                	push   $0x0
  pushl $23
80105614:	6a 17                	push   $0x17
  jmp alltraps
80105616:	e9 04 fb ff ff       	jmp    8010511f <alltraps>

8010561b <vector24>:
.globl vector24
vector24:
  pushl $0
8010561b:	6a 00                	push   $0x0
  pushl $24
8010561d:	6a 18                	push   $0x18
  jmp alltraps
8010561f:	e9 fb fa ff ff       	jmp    8010511f <alltraps>

80105624 <vector25>:
.globl vector25
vector25:
  pushl $0
80105624:	6a 00                	push   $0x0
  pushl $25
80105626:	6a 19                	push   $0x19
  jmp alltraps
80105628:	e9 f2 fa ff ff       	jmp    8010511f <alltraps>

8010562d <vector26>:
.globl vector26
vector26:
  pushl $0
8010562d:	6a 00                	push   $0x0
  pushl $26
8010562f:	6a 1a                	push   $0x1a
  jmp alltraps
80105631:	e9 e9 fa ff ff       	jmp    8010511f <alltraps>

80105636 <vector27>:
.globl vector27
vector27:
  pushl $0
80105636:	6a 00                	push   $0x0
  pushl $27
80105638:	6a 1b                	push   $0x1b
  jmp alltraps
8010563a:	e9 e0 fa ff ff       	jmp    8010511f <alltraps>

8010563f <vector28>:
.globl vector28
vector28:
  pushl $0
8010563f:	6a 00                	push   $0x0
  pushl $28
80105641:	6a 1c                	push   $0x1c
  jmp alltraps
80105643:	e9 d7 fa ff ff       	jmp    8010511f <alltraps>

80105648 <vector29>:
.globl vector29
vector29:
  pushl $0
80105648:	6a 00                	push   $0x0
  pushl $29
8010564a:	6a 1d                	push   $0x1d
  jmp alltraps
8010564c:	e9 ce fa ff ff       	jmp    8010511f <alltraps>

80105651 <vector30>:
.globl vector30
vector30:
  pushl $0
80105651:	6a 00                	push   $0x0
  pushl $30
80105653:	6a 1e                	push   $0x1e
  jmp alltraps
80105655:	e9 c5 fa ff ff       	jmp    8010511f <alltraps>

8010565a <vector31>:
.globl vector31
vector31:
  pushl $0
8010565a:	6a 00                	push   $0x0
  pushl $31
8010565c:	6a 1f                	push   $0x1f
  jmp alltraps
8010565e:	e9 bc fa ff ff       	jmp    8010511f <alltraps>

80105663 <vector32>:
.globl vector32
vector32:
  pushl $0
80105663:	6a 00                	push   $0x0
  pushl $32
80105665:	6a 20                	push   $0x20
  jmp alltraps
80105667:	e9 b3 fa ff ff       	jmp    8010511f <alltraps>

8010566c <vector33>:
.globl vector33
vector33:
  pushl $0
8010566c:	6a 00                	push   $0x0
  pushl $33
8010566e:	6a 21                	push   $0x21
  jmp alltraps
80105670:	e9 aa fa ff ff       	jmp    8010511f <alltraps>

80105675 <vector34>:
.globl vector34
vector34:
  pushl $0
80105675:	6a 00                	push   $0x0
  pushl $34
80105677:	6a 22                	push   $0x22
  jmp alltraps
80105679:	e9 a1 fa ff ff       	jmp    8010511f <alltraps>

8010567e <vector35>:
.globl vector35
vector35:
  pushl $0
8010567e:	6a 00                	push   $0x0
  pushl $35
80105680:	6a 23                	push   $0x23
  jmp alltraps
80105682:	e9 98 fa ff ff       	jmp    8010511f <alltraps>

80105687 <vector36>:
.globl vector36
vector36:
  pushl $0
80105687:	6a 00                	push   $0x0
  pushl $36
80105689:	6a 24                	push   $0x24
  jmp alltraps
8010568b:	e9 8f fa ff ff       	jmp    8010511f <alltraps>

80105690 <vector37>:
.globl vector37
vector37:
  pushl $0
80105690:	6a 00                	push   $0x0
  pushl $37
80105692:	6a 25                	push   $0x25
  jmp alltraps
80105694:	e9 86 fa ff ff       	jmp    8010511f <alltraps>

80105699 <vector38>:
.globl vector38
vector38:
  pushl $0
80105699:	6a 00                	push   $0x0
  pushl $38
8010569b:	6a 26                	push   $0x26
  jmp alltraps
8010569d:	e9 7d fa ff ff       	jmp    8010511f <alltraps>

801056a2 <vector39>:
.globl vector39
vector39:
  pushl $0
801056a2:	6a 00                	push   $0x0
  pushl $39
801056a4:	6a 27                	push   $0x27
  jmp alltraps
801056a6:	e9 74 fa ff ff       	jmp    8010511f <alltraps>

801056ab <vector40>:
.globl vector40
vector40:
  pushl $0
801056ab:	6a 00                	push   $0x0
  pushl $40
801056ad:	6a 28                	push   $0x28
  jmp alltraps
801056af:	e9 6b fa ff ff       	jmp    8010511f <alltraps>

801056b4 <vector41>:
.globl vector41
vector41:
  pushl $0
801056b4:	6a 00                	push   $0x0
  pushl $41
801056b6:	6a 29                	push   $0x29
  jmp alltraps
801056b8:	e9 62 fa ff ff       	jmp    8010511f <alltraps>

801056bd <vector42>:
.globl vector42
vector42:
  pushl $0
801056bd:	6a 00                	push   $0x0
  pushl $42
801056bf:	6a 2a                	push   $0x2a
  jmp alltraps
801056c1:	e9 59 fa ff ff       	jmp    8010511f <alltraps>

801056c6 <vector43>:
.globl vector43
vector43:
  pushl $0
801056c6:	6a 00                	push   $0x0
  pushl $43
801056c8:	6a 2b                	push   $0x2b
  jmp alltraps
801056ca:	e9 50 fa ff ff       	jmp    8010511f <alltraps>

801056cf <vector44>:
.globl vector44
vector44:
  pushl $0
801056cf:	6a 00                	push   $0x0
  pushl $44
801056d1:	6a 2c                	push   $0x2c
  jmp alltraps
801056d3:	e9 47 fa ff ff       	jmp    8010511f <alltraps>

801056d8 <vector45>:
.globl vector45
vector45:
  pushl $0
801056d8:	6a 00                	push   $0x0
  pushl $45
801056da:	6a 2d                	push   $0x2d
  jmp alltraps
801056dc:	e9 3e fa ff ff       	jmp    8010511f <alltraps>

801056e1 <vector46>:
.globl vector46
vector46:
  pushl $0
801056e1:	6a 00                	push   $0x0
  pushl $46
801056e3:	6a 2e                	push   $0x2e
  jmp alltraps
801056e5:	e9 35 fa ff ff       	jmp    8010511f <alltraps>

801056ea <vector47>:
.globl vector47
vector47:
  pushl $0
801056ea:	6a 00                	push   $0x0
  pushl $47
801056ec:	6a 2f                	push   $0x2f
  jmp alltraps
801056ee:	e9 2c fa ff ff       	jmp    8010511f <alltraps>

801056f3 <vector48>:
.globl vector48
vector48:
  pushl $0
801056f3:	6a 00                	push   $0x0
  pushl $48
801056f5:	6a 30                	push   $0x30
  jmp alltraps
801056f7:	e9 23 fa ff ff       	jmp    8010511f <alltraps>

801056fc <vector49>:
.globl vector49
vector49:
  pushl $0
801056fc:	6a 00                	push   $0x0
  pushl $49
801056fe:	6a 31                	push   $0x31
  jmp alltraps
80105700:	e9 1a fa ff ff       	jmp    8010511f <alltraps>

80105705 <vector50>:
.globl vector50
vector50:
  pushl $0
80105705:	6a 00                	push   $0x0
  pushl $50
80105707:	6a 32                	push   $0x32
  jmp alltraps
80105709:	e9 11 fa ff ff       	jmp    8010511f <alltraps>

8010570e <vector51>:
.globl vector51
vector51:
  pushl $0
8010570e:	6a 00                	push   $0x0
  pushl $51
80105710:	6a 33                	push   $0x33
  jmp alltraps
80105712:	e9 08 fa ff ff       	jmp    8010511f <alltraps>

80105717 <vector52>:
.globl vector52
vector52:
  pushl $0
80105717:	6a 00                	push   $0x0
  pushl $52
80105719:	6a 34                	push   $0x34
  jmp alltraps
8010571b:	e9 ff f9 ff ff       	jmp    8010511f <alltraps>

80105720 <vector53>:
.globl vector53
vector53:
  pushl $0
80105720:	6a 00                	push   $0x0
  pushl $53
80105722:	6a 35                	push   $0x35
  jmp alltraps
80105724:	e9 f6 f9 ff ff       	jmp    8010511f <alltraps>

80105729 <vector54>:
.globl vector54
vector54:
  pushl $0
80105729:	6a 00                	push   $0x0
  pushl $54
8010572b:	6a 36                	push   $0x36
  jmp alltraps
8010572d:	e9 ed f9 ff ff       	jmp    8010511f <alltraps>

80105732 <vector55>:
.globl vector55
vector55:
  pushl $0
80105732:	6a 00                	push   $0x0
  pushl $55
80105734:	6a 37                	push   $0x37
  jmp alltraps
80105736:	e9 e4 f9 ff ff       	jmp    8010511f <alltraps>

8010573b <vector56>:
.globl vector56
vector56:
  pushl $0
8010573b:	6a 00                	push   $0x0
  pushl $56
8010573d:	6a 38                	push   $0x38
  jmp alltraps
8010573f:	e9 db f9 ff ff       	jmp    8010511f <alltraps>

80105744 <vector57>:
.globl vector57
vector57:
  pushl $0
80105744:	6a 00                	push   $0x0
  pushl $57
80105746:	6a 39                	push   $0x39
  jmp alltraps
80105748:	e9 d2 f9 ff ff       	jmp    8010511f <alltraps>

8010574d <vector58>:
.globl vector58
vector58:
  pushl $0
8010574d:	6a 00                	push   $0x0
  pushl $58
8010574f:	6a 3a                	push   $0x3a
  jmp alltraps
80105751:	e9 c9 f9 ff ff       	jmp    8010511f <alltraps>

80105756 <vector59>:
.globl vector59
vector59:
  pushl $0
80105756:	6a 00                	push   $0x0
  pushl $59
80105758:	6a 3b                	push   $0x3b
  jmp alltraps
8010575a:	e9 c0 f9 ff ff       	jmp    8010511f <alltraps>

8010575f <vector60>:
.globl vector60
vector60:
  pushl $0
8010575f:	6a 00                	push   $0x0
  pushl $60
80105761:	6a 3c                	push   $0x3c
  jmp alltraps
80105763:	e9 b7 f9 ff ff       	jmp    8010511f <alltraps>

80105768 <vector61>:
.globl vector61
vector61:
  pushl $0
80105768:	6a 00                	push   $0x0
  pushl $61
8010576a:	6a 3d                	push   $0x3d
  jmp alltraps
8010576c:	e9 ae f9 ff ff       	jmp    8010511f <alltraps>

80105771 <vector62>:
.globl vector62
vector62:
  pushl $0
80105771:	6a 00                	push   $0x0
  pushl $62
80105773:	6a 3e                	push   $0x3e
  jmp alltraps
80105775:	e9 a5 f9 ff ff       	jmp    8010511f <alltraps>

8010577a <vector63>:
.globl vector63
vector63:
  pushl $0
8010577a:	6a 00                	push   $0x0
  pushl $63
8010577c:	6a 3f                	push   $0x3f
  jmp alltraps
8010577e:	e9 9c f9 ff ff       	jmp    8010511f <alltraps>

80105783 <vector64>:
.globl vector64
vector64:
  pushl $0
80105783:	6a 00                	push   $0x0
  pushl $64
80105785:	6a 40                	push   $0x40
  jmp alltraps
80105787:	e9 93 f9 ff ff       	jmp    8010511f <alltraps>

8010578c <vector65>:
.globl vector65
vector65:
  pushl $0
8010578c:	6a 00                	push   $0x0
  pushl $65
8010578e:	6a 41                	push   $0x41
  jmp alltraps
80105790:	e9 8a f9 ff ff       	jmp    8010511f <alltraps>

80105795 <vector66>:
.globl vector66
vector66:
  pushl $0
80105795:	6a 00                	push   $0x0
  pushl $66
80105797:	6a 42                	push   $0x42
  jmp alltraps
80105799:	e9 81 f9 ff ff       	jmp    8010511f <alltraps>

8010579e <vector67>:
.globl vector67
vector67:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $67
801057a0:	6a 43                	push   $0x43
  jmp alltraps
801057a2:	e9 78 f9 ff ff       	jmp    8010511f <alltraps>

801057a7 <vector68>:
.globl vector68
vector68:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $68
801057a9:	6a 44                	push   $0x44
  jmp alltraps
801057ab:	e9 6f f9 ff ff       	jmp    8010511f <alltraps>

801057b0 <vector69>:
.globl vector69
vector69:
  pushl $0
801057b0:	6a 00                	push   $0x0
  pushl $69
801057b2:	6a 45                	push   $0x45
  jmp alltraps
801057b4:	e9 66 f9 ff ff       	jmp    8010511f <alltraps>

801057b9 <vector70>:
.globl vector70
vector70:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $70
801057bb:	6a 46                	push   $0x46
  jmp alltraps
801057bd:	e9 5d f9 ff ff       	jmp    8010511f <alltraps>

801057c2 <vector71>:
.globl vector71
vector71:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $71
801057c4:	6a 47                	push   $0x47
  jmp alltraps
801057c6:	e9 54 f9 ff ff       	jmp    8010511f <alltraps>

801057cb <vector72>:
.globl vector72
vector72:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $72
801057cd:	6a 48                	push   $0x48
  jmp alltraps
801057cf:	e9 4b f9 ff ff       	jmp    8010511f <alltraps>

801057d4 <vector73>:
.globl vector73
vector73:
  pushl $0
801057d4:	6a 00                	push   $0x0
  pushl $73
801057d6:	6a 49                	push   $0x49
  jmp alltraps
801057d8:	e9 42 f9 ff ff       	jmp    8010511f <alltraps>

801057dd <vector74>:
.globl vector74
vector74:
  pushl $0
801057dd:	6a 00                	push   $0x0
  pushl $74
801057df:	6a 4a                	push   $0x4a
  jmp alltraps
801057e1:	e9 39 f9 ff ff       	jmp    8010511f <alltraps>

801057e6 <vector75>:
.globl vector75
vector75:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $75
801057e8:	6a 4b                	push   $0x4b
  jmp alltraps
801057ea:	e9 30 f9 ff ff       	jmp    8010511f <alltraps>

801057ef <vector76>:
.globl vector76
vector76:
  pushl $0
801057ef:	6a 00                	push   $0x0
  pushl $76
801057f1:	6a 4c                	push   $0x4c
  jmp alltraps
801057f3:	e9 27 f9 ff ff       	jmp    8010511f <alltraps>

801057f8 <vector77>:
.globl vector77
vector77:
  pushl $0
801057f8:	6a 00                	push   $0x0
  pushl $77
801057fa:	6a 4d                	push   $0x4d
  jmp alltraps
801057fc:	e9 1e f9 ff ff       	jmp    8010511f <alltraps>

80105801 <vector78>:
.globl vector78
vector78:
  pushl $0
80105801:	6a 00                	push   $0x0
  pushl $78
80105803:	6a 4e                	push   $0x4e
  jmp alltraps
80105805:	e9 15 f9 ff ff       	jmp    8010511f <alltraps>

8010580a <vector79>:
.globl vector79
vector79:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $79
8010580c:	6a 4f                	push   $0x4f
  jmp alltraps
8010580e:	e9 0c f9 ff ff       	jmp    8010511f <alltraps>

80105813 <vector80>:
.globl vector80
vector80:
  pushl $0
80105813:	6a 00                	push   $0x0
  pushl $80
80105815:	6a 50                	push   $0x50
  jmp alltraps
80105817:	e9 03 f9 ff ff       	jmp    8010511f <alltraps>

8010581c <vector81>:
.globl vector81
vector81:
  pushl $0
8010581c:	6a 00                	push   $0x0
  pushl $81
8010581e:	6a 51                	push   $0x51
  jmp alltraps
80105820:	e9 fa f8 ff ff       	jmp    8010511f <alltraps>

80105825 <vector82>:
.globl vector82
vector82:
  pushl $0
80105825:	6a 00                	push   $0x0
  pushl $82
80105827:	6a 52                	push   $0x52
  jmp alltraps
80105829:	e9 f1 f8 ff ff       	jmp    8010511f <alltraps>

8010582e <vector83>:
.globl vector83
vector83:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $83
80105830:	6a 53                	push   $0x53
  jmp alltraps
80105832:	e9 e8 f8 ff ff       	jmp    8010511f <alltraps>

80105837 <vector84>:
.globl vector84
vector84:
  pushl $0
80105837:	6a 00                	push   $0x0
  pushl $84
80105839:	6a 54                	push   $0x54
  jmp alltraps
8010583b:	e9 df f8 ff ff       	jmp    8010511f <alltraps>

80105840 <vector85>:
.globl vector85
vector85:
  pushl $0
80105840:	6a 00                	push   $0x0
  pushl $85
80105842:	6a 55                	push   $0x55
  jmp alltraps
80105844:	e9 d6 f8 ff ff       	jmp    8010511f <alltraps>

80105849 <vector86>:
.globl vector86
vector86:
  pushl $0
80105849:	6a 00                	push   $0x0
  pushl $86
8010584b:	6a 56                	push   $0x56
  jmp alltraps
8010584d:	e9 cd f8 ff ff       	jmp    8010511f <alltraps>

80105852 <vector87>:
.globl vector87
vector87:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $87
80105854:	6a 57                	push   $0x57
  jmp alltraps
80105856:	e9 c4 f8 ff ff       	jmp    8010511f <alltraps>

8010585b <vector88>:
.globl vector88
vector88:
  pushl $0
8010585b:	6a 00                	push   $0x0
  pushl $88
8010585d:	6a 58                	push   $0x58
  jmp alltraps
8010585f:	e9 bb f8 ff ff       	jmp    8010511f <alltraps>

80105864 <vector89>:
.globl vector89
vector89:
  pushl $0
80105864:	6a 00                	push   $0x0
  pushl $89
80105866:	6a 59                	push   $0x59
  jmp alltraps
80105868:	e9 b2 f8 ff ff       	jmp    8010511f <alltraps>

8010586d <vector90>:
.globl vector90
vector90:
  pushl $0
8010586d:	6a 00                	push   $0x0
  pushl $90
8010586f:	6a 5a                	push   $0x5a
  jmp alltraps
80105871:	e9 a9 f8 ff ff       	jmp    8010511f <alltraps>

80105876 <vector91>:
.globl vector91
vector91:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $91
80105878:	6a 5b                	push   $0x5b
  jmp alltraps
8010587a:	e9 a0 f8 ff ff       	jmp    8010511f <alltraps>

8010587f <vector92>:
.globl vector92
vector92:
  pushl $0
8010587f:	6a 00                	push   $0x0
  pushl $92
80105881:	6a 5c                	push   $0x5c
  jmp alltraps
80105883:	e9 97 f8 ff ff       	jmp    8010511f <alltraps>

80105888 <vector93>:
.globl vector93
vector93:
  pushl $0
80105888:	6a 00                	push   $0x0
  pushl $93
8010588a:	6a 5d                	push   $0x5d
  jmp alltraps
8010588c:	e9 8e f8 ff ff       	jmp    8010511f <alltraps>

80105891 <vector94>:
.globl vector94
vector94:
  pushl $0
80105891:	6a 00                	push   $0x0
  pushl $94
80105893:	6a 5e                	push   $0x5e
  jmp alltraps
80105895:	e9 85 f8 ff ff       	jmp    8010511f <alltraps>

8010589a <vector95>:
.globl vector95
vector95:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $95
8010589c:	6a 5f                	push   $0x5f
  jmp alltraps
8010589e:	e9 7c f8 ff ff       	jmp    8010511f <alltraps>

801058a3 <vector96>:
.globl vector96
vector96:
  pushl $0
801058a3:	6a 00                	push   $0x0
  pushl $96
801058a5:	6a 60                	push   $0x60
  jmp alltraps
801058a7:	e9 73 f8 ff ff       	jmp    8010511f <alltraps>

801058ac <vector97>:
.globl vector97
vector97:
  pushl $0
801058ac:	6a 00                	push   $0x0
  pushl $97
801058ae:	6a 61                	push   $0x61
  jmp alltraps
801058b0:	e9 6a f8 ff ff       	jmp    8010511f <alltraps>

801058b5 <vector98>:
.globl vector98
vector98:
  pushl $0
801058b5:	6a 00                	push   $0x0
  pushl $98
801058b7:	6a 62                	push   $0x62
  jmp alltraps
801058b9:	e9 61 f8 ff ff       	jmp    8010511f <alltraps>

801058be <vector99>:
.globl vector99
vector99:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $99
801058c0:	6a 63                	push   $0x63
  jmp alltraps
801058c2:	e9 58 f8 ff ff       	jmp    8010511f <alltraps>

801058c7 <vector100>:
.globl vector100
vector100:
  pushl $0
801058c7:	6a 00                	push   $0x0
  pushl $100
801058c9:	6a 64                	push   $0x64
  jmp alltraps
801058cb:	e9 4f f8 ff ff       	jmp    8010511f <alltraps>

801058d0 <vector101>:
.globl vector101
vector101:
  pushl $0
801058d0:	6a 00                	push   $0x0
  pushl $101
801058d2:	6a 65                	push   $0x65
  jmp alltraps
801058d4:	e9 46 f8 ff ff       	jmp    8010511f <alltraps>

801058d9 <vector102>:
.globl vector102
vector102:
  pushl $0
801058d9:	6a 00                	push   $0x0
  pushl $102
801058db:	6a 66                	push   $0x66
  jmp alltraps
801058dd:	e9 3d f8 ff ff       	jmp    8010511f <alltraps>

801058e2 <vector103>:
.globl vector103
vector103:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $103
801058e4:	6a 67                	push   $0x67
  jmp alltraps
801058e6:	e9 34 f8 ff ff       	jmp    8010511f <alltraps>

801058eb <vector104>:
.globl vector104
vector104:
  pushl $0
801058eb:	6a 00                	push   $0x0
  pushl $104
801058ed:	6a 68                	push   $0x68
  jmp alltraps
801058ef:	e9 2b f8 ff ff       	jmp    8010511f <alltraps>

801058f4 <vector105>:
.globl vector105
vector105:
  pushl $0
801058f4:	6a 00                	push   $0x0
  pushl $105
801058f6:	6a 69                	push   $0x69
  jmp alltraps
801058f8:	e9 22 f8 ff ff       	jmp    8010511f <alltraps>

801058fd <vector106>:
.globl vector106
vector106:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $106
801058ff:	6a 6a                	push   $0x6a
  jmp alltraps
80105901:	e9 19 f8 ff ff       	jmp    8010511f <alltraps>

80105906 <vector107>:
.globl vector107
vector107:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $107
80105908:	6a 6b                	push   $0x6b
  jmp alltraps
8010590a:	e9 10 f8 ff ff       	jmp    8010511f <alltraps>

8010590f <vector108>:
.globl vector108
vector108:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $108
80105911:	6a 6c                	push   $0x6c
  jmp alltraps
80105913:	e9 07 f8 ff ff       	jmp    8010511f <alltraps>

80105918 <vector109>:
.globl vector109
vector109:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $109
8010591a:	6a 6d                	push   $0x6d
  jmp alltraps
8010591c:	e9 fe f7 ff ff       	jmp    8010511f <alltraps>

80105921 <vector110>:
.globl vector110
vector110:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $110
80105923:	6a 6e                	push   $0x6e
  jmp alltraps
80105925:	e9 f5 f7 ff ff       	jmp    8010511f <alltraps>

8010592a <vector111>:
.globl vector111
vector111:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $111
8010592c:	6a 6f                	push   $0x6f
  jmp alltraps
8010592e:	e9 ec f7 ff ff       	jmp    8010511f <alltraps>

80105933 <vector112>:
.globl vector112
vector112:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $112
80105935:	6a 70                	push   $0x70
  jmp alltraps
80105937:	e9 e3 f7 ff ff       	jmp    8010511f <alltraps>

8010593c <vector113>:
.globl vector113
vector113:
  pushl $0
8010593c:	6a 00                	push   $0x0
  pushl $113
8010593e:	6a 71                	push   $0x71
  jmp alltraps
80105940:	e9 da f7 ff ff       	jmp    8010511f <alltraps>

80105945 <vector114>:
.globl vector114
vector114:
  pushl $0
80105945:	6a 00                	push   $0x0
  pushl $114
80105947:	6a 72                	push   $0x72
  jmp alltraps
80105949:	e9 d1 f7 ff ff       	jmp    8010511f <alltraps>

8010594e <vector115>:
.globl vector115
vector115:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $115
80105950:	6a 73                	push   $0x73
  jmp alltraps
80105952:	e9 c8 f7 ff ff       	jmp    8010511f <alltraps>

80105957 <vector116>:
.globl vector116
vector116:
  pushl $0
80105957:	6a 00                	push   $0x0
  pushl $116
80105959:	6a 74                	push   $0x74
  jmp alltraps
8010595b:	e9 bf f7 ff ff       	jmp    8010511f <alltraps>

80105960 <vector117>:
.globl vector117
vector117:
  pushl $0
80105960:	6a 00                	push   $0x0
  pushl $117
80105962:	6a 75                	push   $0x75
  jmp alltraps
80105964:	e9 b6 f7 ff ff       	jmp    8010511f <alltraps>

80105969 <vector118>:
.globl vector118
vector118:
  pushl $0
80105969:	6a 00                	push   $0x0
  pushl $118
8010596b:	6a 76                	push   $0x76
  jmp alltraps
8010596d:	e9 ad f7 ff ff       	jmp    8010511f <alltraps>

80105972 <vector119>:
.globl vector119
vector119:
  pushl $0
80105972:	6a 00                	push   $0x0
  pushl $119
80105974:	6a 77                	push   $0x77
  jmp alltraps
80105976:	e9 a4 f7 ff ff       	jmp    8010511f <alltraps>

8010597b <vector120>:
.globl vector120
vector120:
  pushl $0
8010597b:	6a 00                	push   $0x0
  pushl $120
8010597d:	6a 78                	push   $0x78
  jmp alltraps
8010597f:	e9 9b f7 ff ff       	jmp    8010511f <alltraps>

80105984 <vector121>:
.globl vector121
vector121:
  pushl $0
80105984:	6a 00                	push   $0x0
  pushl $121
80105986:	6a 79                	push   $0x79
  jmp alltraps
80105988:	e9 92 f7 ff ff       	jmp    8010511f <alltraps>

8010598d <vector122>:
.globl vector122
vector122:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $122
8010598f:	6a 7a                	push   $0x7a
  jmp alltraps
80105991:	e9 89 f7 ff ff       	jmp    8010511f <alltraps>

80105996 <vector123>:
.globl vector123
vector123:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $123
80105998:	6a 7b                	push   $0x7b
  jmp alltraps
8010599a:	e9 80 f7 ff ff       	jmp    8010511f <alltraps>

8010599f <vector124>:
.globl vector124
vector124:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $124
801059a1:	6a 7c                	push   $0x7c
  jmp alltraps
801059a3:	e9 77 f7 ff ff       	jmp    8010511f <alltraps>

801059a8 <vector125>:
.globl vector125
vector125:
  pushl $0
801059a8:	6a 00                	push   $0x0
  pushl $125
801059aa:	6a 7d                	push   $0x7d
  jmp alltraps
801059ac:	e9 6e f7 ff ff       	jmp    8010511f <alltraps>

801059b1 <vector126>:
.globl vector126
vector126:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $126
801059b3:	6a 7e                	push   $0x7e
  jmp alltraps
801059b5:	e9 65 f7 ff ff       	jmp    8010511f <alltraps>

801059ba <vector127>:
.globl vector127
vector127:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $127
801059bc:	6a 7f                	push   $0x7f
  jmp alltraps
801059be:	e9 5c f7 ff ff       	jmp    8010511f <alltraps>

801059c3 <vector128>:
.globl vector128
vector128:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $128
801059c5:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801059ca:	e9 50 f7 ff ff       	jmp    8010511f <alltraps>

801059cf <vector129>:
.globl vector129
vector129:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $129
801059d1:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801059d6:	e9 44 f7 ff ff       	jmp    8010511f <alltraps>

801059db <vector130>:
.globl vector130
vector130:
  pushl $0
801059db:	6a 00                	push   $0x0
  pushl $130
801059dd:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801059e2:	e9 38 f7 ff ff       	jmp    8010511f <alltraps>

801059e7 <vector131>:
.globl vector131
vector131:
  pushl $0
801059e7:	6a 00                	push   $0x0
  pushl $131
801059e9:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801059ee:	e9 2c f7 ff ff       	jmp    8010511f <alltraps>

801059f3 <vector132>:
.globl vector132
vector132:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $132
801059f5:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801059fa:	e9 20 f7 ff ff       	jmp    8010511f <alltraps>

801059ff <vector133>:
.globl vector133
vector133:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $133
80105a01:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105a06:	e9 14 f7 ff ff       	jmp    8010511f <alltraps>

80105a0b <vector134>:
.globl vector134
vector134:
  pushl $0
80105a0b:	6a 00                	push   $0x0
  pushl $134
80105a0d:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105a12:	e9 08 f7 ff ff       	jmp    8010511f <alltraps>

80105a17 <vector135>:
.globl vector135
vector135:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $135
80105a19:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105a1e:	e9 fc f6 ff ff       	jmp    8010511f <alltraps>

80105a23 <vector136>:
.globl vector136
vector136:
  pushl $0
80105a23:	6a 00                	push   $0x0
  pushl $136
80105a25:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105a2a:	e9 f0 f6 ff ff       	jmp    8010511f <alltraps>

80105a2f <vector137>:
.globl vector137
vector137:
  pushl $0
80105a2f:	6a 00                	push   $0x0
  pushl $137
80105a31:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105a36:	e9 e4 f6 ff ff       	jmp    8010511f <alltraps>

80105a3b <vector138>:
.globl vector138
vector138:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $138
80105a3d:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105a42:	e9 d8 f6 ff ff       	jmp    8010511f <alltraps>

80105a47 <vector139>:
.globl vector139
vector139:
  pushl $0
80105a47:	6a 00                	push   $0x0
  pushl $139
80105a49:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105a4e:	e9 cc f6 ff ff       	jmp    8010511f <alltraps>

80105a53 <vector140>:
.globl vector140
vector140:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $140
80105a55:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105a5a:	e9 c0 f6 ff ff       	jmp    8010511f <alltraps>

80105a5f <vector141>:
.globl vector141
vector141:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $141
80105a61:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105a66:	e9 b4 f6 ff ff       	jmp    8010511f <alltraps>

80105a6b <vector142>:
.globl vector142
vector142:
  pushl $0
80105a6b:	6a 00                	push   $0x0
  pushl $142
80105a6d:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105a72:	e9 a8 f6 ff ff       	jmp    8010511f <alltraps>

80105a77 <vector143>:
.globl vector143
vector143:
  pushl $0
80105a77:	6a 00                	push   $0x0
  pushl $143
80105a79:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105a7e:	e9 9c f6 ff ff       	jmp    8010511f <alltraps>

80105a83 <vector144>:
.globl vector144
vector144:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $144
80105a85:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105a8a:	e9 90 f6 ff ff       	jmp    8010511f <alltraps>

80105a8f <vector145>:
.globl vector145
vector145:
  pushl $0
80105a8f:	6a 00                	push   $0x0
  pushl $145
80105a91:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105a96:	e9 84 f6 ff ff       	jmp    8010511f <alltraps>

80105a9b <vector146>:
.globl vector146
vector146:
  pushl $0
80105a9b:	6a 00                	push   $0x0
  pushl $146
80105a9d:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105aa2:	e9 78 f6 ff ff       	jmp    8010511f <alltraps>

80105aa7 <vector147>:
.globl vector147
vector147:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $147
80105aa9:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105aae:	e9 6c f6 ff ff       	jmp    8010511f <alltraps>

80105ab3 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $148
80105ab5:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105aba:	e9 60 f6 ff ff       	jmp    8010511f <alltraps>

80105abf <vector149>:
.globl vector149
vector149:
  pushl $0
80105abf:	6a 00                	push   $0x0
  pushl $149
80105ac1:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ac6:	e9 54 f6 ff ff       	jmp    8010511f <alltraps>

80105acb <vector150>:
.globl vector150
vector150:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $150
80105acd:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105ad2:	e9 48 f6 ff ff       	jmp    8010511f <alltraps>

80105ad7 <vector151>:
.globl vector151
vector151:
  pushl $0
80105ad7:	6a 00                	push   $0x0
  pushl $151
80105ad9:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ade:	e9 3c f6 ff ff       	jmp    8010511f <alltraps>

80105ae3 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $152
80105ae5:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105aea:	e9 30 f6 ff ff       	jmp    8010511f <alltraps>

80105aef <vector153>:
.globl vector153
vector153:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $153
80105af1:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105af6:	e9 24 f6 ff ff       	jmp    8010511f <alltraps>

80105afb <vector154>:
.globl vector154
vector154:
  pushl $0
80105afb:	6a 00                	push   $0x0
  pushl $154
80105afd:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105b02:	e9 18 f6 ff ff       	jmp    8010511f <alltraps>

80105b07 <vector155>:
.globl vector155
vector155:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $155
80105b09:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105b0e:	e9 0c f6 ff ff       	jmp    8010511f <alltraps>

80105b13 <vector156>:
.globl vector156
vector156:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $156
80105b15:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105b1a:	e9 00 f6 ff ff       	jmp    8010511f <alltraps>

80105b1f <vector157>:
.globl vector157
vector157:
  pushl $0
80105b1f:	6a 00                	push   $0x0
  pushl $157
80105b21:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105b26:	e9 f4 f5 ff ff       	jmp    8010511f <alltraps>

80105b2b <vector158>:
.globl vector158
vector158:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $158
80105b2d:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105b32:	e9 e8 f5 ff ff       	jmp    8010511f <alltraps>

80105b37 <vector159>:
.globl vector159
vector159:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $159
80105b39:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105b3e:	e9 dc f5 ff ff       	jmp    8010511f <alltraps>

80105b43 <vector160>:
.globl vector160
vector160:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $160
80105b45:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105b4a:	e9 d0 f5 ff ff       	jmp    8010511f <alltraps>

80105b4f <vector161>:
.globl vector161
vector161:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $161
80105b51:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105b56:	e9 c4 f5 ff ff       	jmp    8010511f <alltraps>

80105b5b <vector162>:
.globl vector162
vector162:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $162
80105b5d:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105b62:	e9 b8 f5 ff ff       	jmp    8010511f <alltraps>

80105b67 <vector163>:
.globl vector163
vector163:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $163
80105b69:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105b6e:	e9 ac f5 ff ff       	jmp    8010511f <alltraps>

80105b73 <vector164>:
.globl vector164
vector164:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $164
80105b75:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105b7a:	e9 a0 f5 ff ff       	jmp    8010511f <alltraps>

80105b7f <vector165>:
.globl vector165
vector165:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $165
80105b81:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105b86:	e9 94 f5 ff ff       	jmp    8010511f <alltraps>

80105b8b <vector166>:
.globl vector166
vector166:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $166
80105b8d:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105b92:	e9 88 f5 ff ff       	jmp    8010511f <alltraps>

80105b97 <vector167>:
.globl vector167
vector167:
  pushl $0
80105b97:	6a 00                	push   $0x0
  pushl $167
80105b99:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105b9e:	e9 7c f5 ff ff       	jmp    8010511f <alltraps>

80105ba3 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $168
80105ba5:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105baa:	e9 70 f5 ff ff       	jmp    8010511f <alltraps>

80105baf <vector169>:
.globl vector169
vector169:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $169
80105bb1:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105bb6:	e9 64 f5 ff ff       	jmp    8010511f <alltraps>

80105bbb <vector170>:
.globl vector170
vector170:
  pushl $0
80105bbb:	6a 00                	push   $0x0
  pushl $170
80105bbd:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105bc2:	e9 58 f5 ff ff       	jmp    8010511f <alltraps>

80105bc7 <vector171>:
.globl vector171
vector171:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $171
80105bc9:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105bce:	e9 4c f5 ff ff       	jmp    8010511f <alltraps>

80105bd3 <vector172>:
.globl vector172
vector172:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $172
80105bd5:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105bda:	e9 40 f5 ff ff       	jmp    8010511f <alltraps>

80105bdf <vector173>:
.globl vector173
vector173:
  pushl $0
80105bdf:	6a 00                	push   $0x0
  pushl $173
80105be1:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105be6:	e9 34 f5 ff ff       	jmp    8010511f <alltraps>

80105beb <vector174>:
.globl vector174
vector174:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $174
80105bed:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105bf2:	e9 28 f5 ff ff       	jmp    8010511f <alltraps>

80105bf7 <vector175>:
.globl vector175
vector175:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $175
80105bf9:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105bfe:	e9 1c f5 ff ff       	jmp    8010511f <alltraps>

80105c03 <vector176>:
.globl vector176
vector176:
  pushl $0
80105c03:	6a 00                	push   $0x0
  pushl $176
80105c05:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105c0a:	e9 10 f5 ff ff       	jmp    8010511f <alltraps>

80105c0f <vector177>:
.globl vector177
vector177:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $177
80105c11:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105c16:	e9 04 f5 ff ff       	jmp    8010511f <alltraps>

80105c1b <vector178>:
.globl vector178
vector178:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $178
80105c1d:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105c22:	e9 f8 f4 ff ff       	jmp    8010511f <alltraps>

80105c27 <vector179>:
.globl vector179
vector179:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $179
80105c29:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105c2e:	e9 ec f4 ff ff       	jmp    8010511f <alltraps>

80105c33 <vector180>:
.globl vector180
vector180:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $180
80105c35:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105c3a:	e9 e0 f4 ff ff       	jmp    8010511f <alltraps>

80105c3f <vector181>:
.globl vector181
vector181:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $181
80105c41:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105c46:	e9 d4 f4 ff ff       	jmp    8010511f <alltraps>

80105c4b <vector182>:
.globl vector182
vector182:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $182
80105c4d:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105c52:	e9 c8 f4 ff ff       	jmp    8010511f <alltraps>

80105c57 <vector183>:
.globl vector183
vector183:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $183
80105c59:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105c5e:	e9 bc f4 ff ff       	jmp    8010511f <alltraps>

80105c63 <vector184>:
.globl vector184
vector184:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $184
80105c65:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105c6a:	e9 b0 f4 ff ff       	jmp    8010511f <alltraps>

80105c6f <vector185>:
.globl vector185
vector185:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $185
80105c71:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105c76:	e9 a4 f4 ff ff       	jmp    8010511f <alltraps>

80105c7b <vector186>:
.globl vector186
vector186:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $186
80105c7d:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105c82:	e9 98 f4 ff ff       	jmp    8010511f <alltraps>

80105c87 <vector187>:
.globl vector187
vector187:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $187
80105c89:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105c8e:	e9 8c f4 ff ff       	jmp    8010511f <alltraps>

80105c93 <vector188>:
.globl vector188
vector188:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $188
80105c95:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105c9a:	e9 80 f4 ff ff       	jmp    8010511f <alltraps>

80105c9f <vector189>:
.globl vector189
vector189:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $189
80105ca1:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ca6:	e9 74 f4 ff ff       	jmp    8010511f <alltraps>

80105cab <vector190>:
.globl vector190
vector190:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $190
80105cad:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105cb2:	e9 68 f4 ff ff       	jmp    8010511f <alltraps>

80105cb7 <vector191>:
.globl vector191
vector191:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $191
80105cb9:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105cbe:	e9 5c f4 ff ff       	jmp    8010511f <alltraps>

80105cc3 <vector192>:
.globl vector192
vector192:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $192
80105cc5:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105cca:	e9 50 f4 ff ff       	jmp    8010511f <alltraps>

80105ccf <vector193>:
.globl vector193
vector193:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $193
80105cd1:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105cd6:	e9 44 f4 ff ff       	jmp    8010511f <alltraps>

80105cdb <vector194>:
.globl vector194
vector194:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $194
80105cdd:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ce2:	e9 38 f4 ff ff       	jmp    8010511f <alltraps>

80105ce7 <vector195>:
.globl vector195
vector195:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $195
80105ce9:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105cee:	e9 2c f4 ff ff       	jmp    8010511f <alltraps>

80105cf3 <vector196>:
.globl vector196
vector196:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $196
80105cf5:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105cfa:	e9 20 f4 ff ff       	jmp    8010511f <alltraps>

80105cff <vector197>:
.globl vector197
vector197:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $197
80105d01:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105d06:	e9 14 f4 ff ff       	jmp    8010511f <alltraps>

80105d0b <vector198>:
.globl vector198
vector198:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $198
80105d0d:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105d12:	e9 08 f4 ff ff       	jmp    8010511f <alltraps>

80105d17 <vector199>:
.globl vector199
vector199:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $199
80105d19:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105d1e:	e9 fc f3 ff ff       	jmp    8010511f <alltraps>

80105d23 <vector200>:
.globl vector200
vector200:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $200
80105d25:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105d2a:	e9 f0 f3 ff ff       	jmp    8010511f <alltraps>

80105d2f <vector201>:
.globl vector201
vector201:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $201
80105d31:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105d36:	e9 e4 f3 ff ff       	jmp    8010511f <alltraps>

80105d3b <vector202>:
.globl vector202
vector202:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $202
80105d3d:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105d42:	e9 d8 f3 ff ff       	jmp    8010511f <alltraps>

80105d47 <vector203>:
.globl vector203
vector203:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $203
80105d49:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105d4e:	e9 cc f3 ff ff       	jmp    8010511f <alltraps>

80105d53 <vector204>:
.globl vector204
vector204:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $204
80105d55:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105d5a:	e9 c0 f3 ff ff       	jmp    8010511f <alltraps>

80105d5f <vector205>:
.globl vector205
vector205:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $205
80105d61:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105d66:	e9 b4 f3 ff ff       	jmp    8010511f <alltraps>

80105d6b <vector206>:
.globl vector206
vector206:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $206
80105d6d:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105d72:	e9 a8 f3 ff ff       	jmp    8010511f <alltraps>

80105d77 <vector207>:
.globl vector207
vector207:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $207
80105d79:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105d7e:	e9 9c f3 ff ff       	jmp    8010511f <alltraps>

80105d83 <vector208>:
.globl vector208
vector208:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $208
80105d85:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105d8a:	e9 90 f3 ff ff       	jmp    8010511f <alltraps>

80105d8f <vector209>:
.globl vector209
vector209:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $209
80105d91:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105d96:	e9 84 f3 ff ff       	jmp    8010511f <alltraps>

80105d9b <vector210>:
.globl vector210
vector210:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $210
80105d9d:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105da2:	e9 78 f3 ff ff       	jmp    8010511f <alltraps>

80105da7 <vector211>:
.globl vector211
vector211:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $211
80105da9:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105dae:	e9 6c f3 ff ff       	jmp    8010511f <alltraps>

80105db3 <vector212>:
.globl vector212
vector212:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $212
80105db5:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105dba:	e9 60 f3 ff ff       	jmp    8010511f <alltraps>

80105dbf <vector213>:
.globl vector213
vector213:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $213
80105dc1:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105dc6:	e9 54 f3 ff ff       	jmp    8010511f <alltraps>

80105dcb <vector214>:
.globl vector214
vector214:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $214
80105dcd:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105dd2:	e9 48 f3 ff ff       	jmp    8010511f <alltraps>

80105dd7 <vector215>:
.globl vector215
vector215:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $215
80105dd9:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105dde:	e9 3c f3 ff ff       	jmp    8010511f <alltraps>

80105de3 <vector216>:
.globl vector216
vector216:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $216
80105de5:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105dea:	e9 30 f3 ff ff       	jmp    8010511f <alltraps>

80105def <vector217>:
.globl vector217
vector217:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $217
80105df1:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105df6:	e9 24 f3 ff ff       	jmp    8010511f <alltraps>

80105dfb <vector218>:
.globl vector218
vector218:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $218
80105dfd:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105e02:	e9 18 f3 ff ff       	jmp    8010511f <alltraps>

80105e07 <vector219>:
.globl vector219
vector219:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $219
80105e09:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105e0e:	e9 0c f3 ff ff       	jmp    8010511f <alltraps>

80105e13 <vector220>:
.globl vector220
vector220:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $220
80105e15:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105e1a:	e9 00 f3 ff ff       	jmp    8010511f <alltraps>

80105e1f <vector221>:
.globl vector221
vector221:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $221
80105e21:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105e26:	e9 f4 f2 ff ff       	jmp    8010511f <alltraps>

80105e2b <vector222>:
.globl vector222
vector222:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $222
80105e2d:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105e32:	e9 e8 f2 ff ff       	jmp    8010511f <alltraps>

80105e37 <vector223>:
.globl vector223
vector223:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $223
80105e39:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105e3e:	e9 dc f2 ff ff       	jmp    8010511f <alltraps>

80105e43 <vector224>:
.globl vector224
vector224:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $224
80105e45:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105e4a:	e9 d0 f2 ff ff       	jmp    8010511f <alltraps>

80105e4f <vector225>:
.globl vector225
vector225:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $225
80105e51:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105e56:	e9 c4 f2 ff ff       	jmp    8010511f <alltraps>

80105e5b <vector226>:
.globl vector226
vector226:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $226
80105e5d:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105e62:	e9 b8 f2 ff ff       	jmp    8010511f <alltraps>

80105e67 <vector227>:
.globl vector227
vector227:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $227
80105e69:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105e6e:	e9 ac f2 ff ff       	jmp    8010511f <alltraps>

80105e73 <vector228>:
.globl vector228
vector228:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $228
80105e75:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105e7a:	e9 a0 f2 ff ff       	jmp    8010511f <alltraps>

80105e7f <vector229>:
.globl vector229
vector229:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $229
80105e81:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105e86:	e9 94 f2 ff ff       	jmp    8010511f <alltraps>

80105e8b <vector230>:
.globl vector230
vector230:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $230
80105e8d:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105e92:	e9 88 f2 ff ff       	jmp    8010511f <alltraps>

80105e97 <vector231>:
.globl vector231
vector231:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $231
80105e99:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105e9e:	e9 7c f2 ff ff       	jmp    8010511f <alltraps>

80105ea3 <vector232>:
.globl vector232
vector232:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $232
80105ea5:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105eaa:	e9 70 f2 ff ff       	jmp    8010511f <alltraps>

80105eaf <vector233>:
.globl vector233
vector233:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $233
80105eb1:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105eb6:	e9 64 f2 ff ff       	jmp    8010511f <alltraps>

80105ebb <vector234>:
.globl vector234
vector234:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $234
80105ebd:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105ec2:	e9 58 f2 ff ff       	jmp    8010511f <alltraps>

80105ec7 <vector235>:
.globl vector235
vector235:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $235
80105ec9:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105ece:	e9 4c f2 ff ff       	jmp    8010511f <alltraps>

80105ed3 <vector236>:
.globl vector236
vector236:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $236
80105ed5:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105eda:	e9 40 f2 ff ff       	jmp    8010511f <alltraps>

80105edf <vector237>:
.globl vector237
vector237:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $237
80105ee1:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ee6:	e9 34 f2 ff ff       	jmp    8010511f <alltraps>

80105eeb <vector238>:
.globl vector238
vector238:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $238
80105eed:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105ef2:	e9 28 f2 ff ff       	jmp    8010511f <alltraps>

80105ef7 <vector239>:
.globl vector239
vector239:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $239
80105ef9:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105efe:	e9 1c f2 ff ff       	jmp    8010511f <alltraps>

80105f03 <vector240>:
.globl vector240
vector240:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $240
80105f05:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105f0a:	e9 10 f2 ff ff       	jmp    8010511f <alltraps>

80105f0f <vector241>:
.globl vector241
vector241:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $241
80105f11:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105f16:	e9 04 f2 ff ff       	jmp    8010511f <alltraps>

80105f1b <vector242>:
.globl vector242
vector242:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $242
80105f1d:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105f22:	e9 f8 f1 ff ff       	jmp    8010511f <alltraps>

80105f27 <vector243>:
.globl vector243
vector243:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $243
80105f29:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105f2e:	e9 ec f1 ff ff       	jmp    8010511f <alltraps>

80105f33 <vector244>:
.globl vector244
vector244:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $244
80105f35:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105f3a:	e9 e0 f1 ff ff       	jmp    8010511f <alltraps>

80105f3f <vector245>:
.globl vector245
vector245:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $245
80105f41:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105f46:	e9 d4 f1 ff ff       	jmp    8010511f <alltraps>

80105f4b <vector246>:
.globl vector246
vector246:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $246
80105f4d:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105f52:	e9 c8 f1 ff ff       	jmp    8010511f <alltraps>

80105f57 <vector247>:
.globl vector247
vector247:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $247
80105f59:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105f5e:	e9 bc f1 ff ff       	jmp    8010511f <alltraps>

80105f63 <vector248>:
.globl vector248
vector248:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $248
80105f65:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105f6a:	e9 b0 f1 ff ff       	jmp    8010511f <alltraps>

80105f6f <vector249>:
.globl vector249
vector249:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $249
80105f71:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105f76:	e9 a4 f1 ff ff       	jmp    8010511f <alltraps>

80105f7b <vector250>:
.globl vector250
vector250:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $250
80105f7d:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105f82:	e9 98 f1 ff ff       	jmp    8010511f <alltraps>

80105f87 <vector251>:
.globl vector251
vector251:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $251
80105f89:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105f8e:	e9 8c f1 ff ff       	jmp    8010511f <alltraps>

80105f93 <vector252>:
.globl vector252
vector252:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $252
80105f95:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105f9a:	e9 80 f1 ff ff       	jmp    8010511f <alltraps>

80105f9f <vector253>:
.globl vector253
vector253:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $253
80105fa1:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105fa6:	e9 74 f1 ff ff       	jmp    8010511f <alltraps>

80105fab <vector254>:
.globl vector254
vector254:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $254
80105fad:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105fb2:	e9 68 f1 ff ff       	jmp    8010511f <alltraps>

80105fb7 <vector255>:
.globl vector255
vector255:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $255
80105fb9:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105fbe:	e9 5c f1 ff ff       	jmp    8010511f <alltraps>
80105fc3:	90                   	nop

80105fc4 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	57                   	push   %edi
80105fc8:	56                   	push   %esi
80105fc9:	53                   	push   %ebx
80105fca:	83 ec 0c             	sub    $0xc,%esp
80105fcd:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105fcf:	c1 ea 16             	shr    $0x16,%edx
80105fd2:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105fd5:	8b 1f                	mov    (%edi),%ebx
80105fd7:	f6 c3 01             	test   $0x1,%bl
80105fda:	74 20                	je     80105ffc <walkpgdir+0x38>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105fdc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105fe2:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105fe8:	89 f0                	mov    %esi,%eax
80105fea:	c1 e8 0a             	shr    $0xa,%eax
80105fed:	25 fc 0f 00 00       	and    $0xffc,%eax
80105ff2:	01 d8                	add    %ebx,%eax
}
80105ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff7:	5b                   	pop    %ebx
80105ff8:	5e                   	pop    %esi
80105ff9:	5f                   	pop    %edi
80105ffa:	5d                   	pop    %ebp
80105ffb:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105ffc:	85 c9                	test   %ecx,%ecx
80105ffe:	74 2c                	je     8010602c <walkpgdir+0x68>
80106000:	e8 2f c2 ff ff       	call   80102234 <kalloc>
80106005:	89 c3                	mov    %eax,%ebx
80106007:	85 c0                	test   %eax,%eax
80106009:	74 21                	je     8010602c <walkpgdir+0x68>
    memset(pgtab, 0, PGSIZE);
8010600b:	50                   	push   %eax
8010600c:	68 00 10 00 00       	push   $0x1000
80106011:	6a 00                	push   $0x0
80106013:	53                   	push   %ebx
80106014:	e8 43 e1 ff ff       	call   8010415c <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106019:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010601f:	83 c8 07             	or     $0x7,%eax
80106022:	89 07                	mov    %eax,(%edi)
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	eb bf                	jmp    80105fe8 <walkpgdir+0x24>
80106029:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
8010602c:	31 c0                	xor    %eax,%eax
}
8010602e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106031:	5b                   	pop    %ebx
80106032:	5e                   	pop    %esi
80106033:	5f                   	pop    %edi
80106034:	5d                   	pop    %ebp
80106035:	c3                   	ret    
80106036:	66 90                	xchg   %ax,%ax

80106038 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106038:	55                   	push   %ebp
80106039:	89 e5                	mov    %esp,%ebp
8010603b:	57                   	push   %edi
8010603c:	56                   	push   %esi
8010603d:	53                   	push   %ebx
8010603e:	83 ec 1c             	sub    $0x1c,%esp
80106041:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106043:	89 d6                	mov    %edx,%esi
80106045:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010604b:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010604f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106054:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106057:	8b 45 08             	mov    0x8(%ebp),%eax
8010605a:	29 f0                	sub    %esi,%eax
8010605c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010605f:	eb 1b                	jmp    8010607c <mappages+0x44>
80106061:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106064:	f6 00 01             	testb  $0x1,(%eax)
80106067:	75 45                	jne    801060ae <mappages+0x76>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106069:	0b 5d 0c             	or     0xc(%ebp),%ebx
8010606c:	83 cb 01             	or     $0x1,%ebx
8010606f:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106071:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106074:	74 2e                	je     801060a4 <mappages+0x6c>
      break;
    a += PGSIZE;
80106076:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
8010607c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010607f:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106082:	b9 01 00 00 00       	mov    $0x1,%ecx
80106087:	89 f2                	mov    %esi,%edx
80106089:	89 f8                	mov    %edi,%eax
8010608b:	e8 34 ff ff ff       	call   80105fc4 <walkpgdir>
80106090:	85 c0                	test   %eax,%eax
80106092:	75 d0                	jne    80106064 <mappages+0x2c>
      return -1;
80106094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80106099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609c:	5b                   	pop    %ebx
8010609d:	5e                   	pop    %esi
8010609e:	5f                   	pop    %edi
8010609f:	5d                   	pop    %ebp
801060a0:	c3                   	ret    
801060a1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
801060a4:	31 c0                	xor    %eax,%eax
}
801060a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a9:	5b                   	pop    %ebx
801060aa:	5e                   	pop    %esi
801060ab:	5f                   	pop    %edi
801060ac:	5d                   	pop    %ebp
801060ad:	c3                   	ret    
      panic("remap");
801060ae:	83 ec 0c             	sub    $0xc,%esp
801060b1:	68 30 71 10 80       	push   $0x80107130
801060b6:	e8 85 a2 ff ff       	call   80100340 <panic>
801060bb:	90                   	nop

801060bc <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801060bc:	55                   	push   %ebp
801060bd:	89 e5                	mov    %esp,%ebp
801060bf:	57                   	push   %edi
801060c0:	56                   	push   %esi
801060c1:	53                   	push   %ebx
801060c2:	83 ec 1c             	sub    $0x1c,%esp
801060c5:	89 c6                	mov    %eax,%esi
801060c7:	89 d3                	mov    %edx,%ebx
801060c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801060cc:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801060d2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; a  < oldsz; a += PGSIZE){
801060d8:	39 da                	cmp    %ebx,%edx
801060da:	73 53                	jae    8010612f <deallocuvm.part.0+0x73>
801060dc:	89 d7                	mov    %edx,%edi
801060de:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801060e1:	eb 0c                	jmp    801060ef <deallocuvm.part.0+0x33>
801060e3:	90                   	nop
801060e4:	81 c7 00 10 00 00    	add    $0x1000,%edi
801060ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801060ed:	76 40                	jbe    8010612f <deallocuvm.part.0+0x73>
    pte = walkpgdir(pgdir, (char*)a, 0);
801060ef:	31 c9                	xor    %ecx,%ecx
801060f1:	89 fa                	mov    %edi,%edx
801060f3:	89 f0                	mov    %esi,%eax
801060f5:	e8 ca fe ff ff       	call   80105fc4 <walkpgdir>
801060fa:	89 c3                	mov    %eax,%ebx
    if(!pte)
801060fc:	85 c0                	test   %eax,%eax
801060fe:	74 3c                	je     8010613c <deallocuvm.part.0+0x80>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106100:	8b 00                	mov    (%eax),%eax
80106102:	a8 01                	test   $0x1,%al
80106104:	74 de                	je     801060e4 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106106:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010610b:	74 3f                	je     8010614c <deallocuvm.part.0+0x90>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
8010610d:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106110:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106115:	50                   	push   %eax
80106116:	e8 89 bf ff ff       	call   801020a4 <kfree>
      *pte = 0;
8010611b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106121:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106127:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
8010612a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010612d:	77 c0                	ja     801060ef <deallocuvm.part.0+0x33>
    }
  }
  return newsz;
}
8010612f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106135:	5b                   	pop    %ebx
80106136:	5e                   	pop    %esi
80106137:	5f                   	pop    %edi
80106138:	5d                   	pop    %ebp
80106139:	c3                   	ret    
8010613a:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010613c:	89 fa                	mov    %edi,%edx
8010613e:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106144:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010614a:	eb 9e                	jmp    801060ea <deallocuvm.part.0+0x2e>
        panic("kfree");
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	68 a6 6a 10 80       	push   $0x80106aa6
80106154:	e8 e7 a1 ff ff       	call   80100340 <panic>
80106159:	8d 76 00             	lea    0x0(%esi),%esi

8010615c <seginit>:
{
8010615c:	55                   	push   %ebp
8010615d:	89 e5                	mov    %esp,%ebp
8010615f:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106162:	e8 c9 d1 ff ff       	call   80103330 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106167:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010616a:	01 d2                	add    %edx,%edx
8010616c:	01 d0                	add    %edx,%eax
8010616e:	c1 e0 04             	shl    $0x4,%eax
80106171:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106178:	ff 00 00 
8010617b:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106182:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106185:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
8010618c:	ff 00 00 
8010618f:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106196:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106199:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801061a0:	ff 00 00 
801061a3:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801061aa:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801061ad:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801061b4:	ff 00 00 
801061b7:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801061be:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801061c1:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
801061c6:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801061cc:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801061d0:	c1 e8 10             	shr    $0x10,%eax
801061d3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801061d7:	8d 45 f2             	lea    -0xe(%ebp),%eax
801061da:	0f 01 10             	lgdtl  (%eax)
}
801061dd:	c9                   	leave  
801061de:	c3                   	ret    
801061df:	90                   	nop

801061e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801061e0:	a1 a4 56 11 80       	mov    0x801156a4,%eax
801061e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801061ea:	0f 22 d8             	mov    %eax,%cr3
}
801061ed:	c3                   	ret    
801061ee:	66 90                	xchg   %ax,%ax

801061f0 <switchuvm>:
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	57                   	push   %edi
801061f4:	56                   	push   %esi
801061f5:	53                   	push   %ebx
801061f6:	83 ec 1c             	sub    $0x1c,%esp
801061f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801061fc:	85 f6                	test   %esi,%esi
801061fe:	0f 84 bf 00 00 00    	je     801062c3 <switchuvm+0xd3>
  if(p->kstack == 0)
80106204:	8b 56 08             	mov    0x8(%esi),%edx
80106207:	85 d2                	test   %edx,%edx
80106209:	0f 84 ce 00 00 00    	je     801062dd <switchuvm+0xed>
  if(p->pgdir == 0)
8010620f:	8b 46 04             	mov    0x4(%esi),%eax
80106212:	85 c0                	test   %eax,%eax
80106214:	0f 84 b6 00 00 00    	je     801062d0 <switchuvm+0xe0>
  pushcli();
8010621a:	e8 81 dd ff ff       	call   80103fa0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010621f:	e8 a8 d0 ff ff       	call   801032cc <mycpu>
80106224:	89 c3                	mov    %eax,%ebx
80106226:	e8 a1 d0 ff ff       	call   801032cc <mycpu>
8010622b:	89 c7                	mov    %eax,%edi
8010622d:	e8 9a d0 ff ff       	call   801032cc <mycpu>
80106232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106235:	e8 92 d0 ff ff       	call   801032cc <mycpu>
8010623a:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106241:	67 00 
80106243:	83 c7 08             	add    $0x8,%edi
80106246:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010624d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106250:	83 c1 08             	add    $0x8,%ecx
80106253:	c1 e9 10             	shr    $0x10,%ecx
80106256:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010625c:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
80106263:	99 40 
80106265:	83 c0 08             	add    $0x8,%eax
80106268:	c1 e8 18             	shr    $0x18,%eax
8010626b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
80106271:	e8 56 d0 ff ff       	call   801032cc <mycpu>
80106276:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010627d:	e8 4a d0 ff ff       	call   801032cc <mycpu>
80106282:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106288:	8b 5e 08             	mov    0x8(%esi),%ebx
8010628b:	e8 3c d0 ff ff       	call   801032cc <mycpu>
80106290:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106296:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106299:	e8 2e d0 ff ff       	call   801032cc <mycpu>
8010629e:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801062a4:	b8 28 00 00 00       	mov    $0x28,%eax
801062a9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801062ac:	8b 46 04             	mov    0x4(%esi),%eax
801062af:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801062b4:	0f 22 d8             	mov    %eax,%cr3
}
801062b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062ba:	5b                   	pop    %ebx
801062bb:	5e                   	pop    %esi
801062bc:	5f                   	pop    %edi
801062bd:	5d                   	pop    %ebp
  popcli();
801062be:	e9 25 dd ff ff       	jmp    80103fe8 <popcli>
    panic("switchuvm: no process");
801062c3:	83 ec 0c             	sub    $0xc,%esp
801062c6:	68 36 71 10 80       	push   $0x80107136
801062cb:	e8 70 a0 ff ff       	call   80100340 <panic>
    panic("switchuvm: no pgdir");
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	68 61 71 10 80       	push   $0x80107161
801062d8:	e8 63 a0 ff ff       	call   80100340 <panic>
    panic("switchuvm: no kstack");
801062dd:	83 ec 0c             	sub    $0xc,%esp
801062e0:	68 4c 71 10 80       	push   $0x8010714c
801062e5:	e8 56 a0 ff ff       	call   80100340 <panic>
801062ea:	66 90                	xchg   %ax,%ax

801062ec <inituvm>:
{
801062ec:	55                   	push   %ebp
801062ed:	89 e5                	mov    %esp,%ebp
801062ef:	57                   	push   %edi
801062f0:	56                   	push   %esi
801062f1:	53                   	push   %ebx
801062f2:	83 ec 1c             	sub    $0x1c,%esp
801062f5:	8b 45 08             	mov    0x8(%ebp),%eax
801062f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
801062fe:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106301:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106307:	77 47                	ja     80106350 <inituvm+0x64>
  mem = kalloc();
80106309:	e8 26 bf ff ff       	call   80102234 <kalloc>
8010630e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106310:	50                   	push   %eax
80106311:	68 00 10 00 00       	push   $0x1000
80106316:	6a 00                	push   $0x0
80106318:	53                   	push   %ebx
80106319:	e8 3e de ff ff       	call   8010415c <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010631e:	5a                   	pop    %edx
8010631f:	59                   	pop    %ecx
80106320:	6a 06                	push   $0x6
80106322:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106328:	50                   	push   %eax
80106329:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010632e:	31 d2                	xor    %edx,%edx
80106330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106333:	e8 00 fd ff ff       	call   80106038 <mappages>
  memmove(mem, init, sz);
80106338:	83 c4 10             	add    $0x10,%esp
8010633b:	89 75 10             	mov    %esi,0x10(%ebp)
8010633e:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106341:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106344:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106347:	5b                   	pop    %ebx
80106348:	5e                   	pop    %esi
80106349:	5f                   	pop    %edi
8010634a:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010634b:	e9 90 de ff ff       	jmp    801041e0 <memmove>
    panic("inituvm: more than a page");
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	68 75 71 10 80       	push   $0x80107175
80106358:	e8 e3 9f ff ff       	call   80100340 <panic>
8010635d:	8d 76 00             	lea    0x0(%esi),%esi

80106360 <loaduvm>:
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
80106366:	83 ec 1c             	sub    $0x1c,%esp
80106369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010636c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010636f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106374:	0f 85 94 00 00 00    	jne    8010640e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
8010637a:	85 f6                	test   %esi,%esi
8010637c:	74 6a                	je     801063e8 <loaduvm+0x88>
8010637e:	89 f3                	mov    %esi,%ebx
80106380:	01 f0                	add    %esi,%eax
80106382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106385:	8b 45 14             	mov    0x14(%ebp),%eax
80106388:	01 f0                	add    %esi,%eax
8010638a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010638d:	eb 2d                	jmp    801063bc <loaduvm+0x5c>
8010638f:	90                   	nop
    if(sz - i < PGSIZE)
80106390:	89 df                	mov    %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106392:	57                   	push   %edi
80106393:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106396:	29 d9                	sub    %ebx,%ecx
80106398:	51                   	push   %ecx
80106399:	05 00 00 00 80       	add    $0x80000000,%eax
8010639e:	50                   	push   %eax
8010639f:	ff 75 10             	pushl  0x10(%ebp)
801063a2:	e8 59 b4 ff ff       	call   80101800 <readi>
801063a7:	83 c4 10             	add    $0x10,%esp
801063aa:	39 f8                	cmp    %edi,%eax
801063ac:	75 46                	jne    801063f4 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
801063ae:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801063b4:	89 f0                	mov    %esi,%eax
801063b6:	29 d8                	sub    %ebx,%eax
801063b8:	39 c6                	cmp    %eax,%esi
801063ba:	76 2c                	jbe    801063e8 <loaduvm+0x88>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801063bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801063bf:	29 da                	sub    %ebx,%edx
801063c1:	31 c9                	xor    %ecx,%ecx
801063c3:	8b 45 08             	mov    0x8(%ebp),%eax
801063c6:	e8 f9 fb ff ff       	call   80105fc4 <walkpgdir>
801063cb:	85 c0                	test   %eax,%eax
801063cd:	74 32                	je     80106401 <loaduvm+0xa1>
    pa = PTE_ADDR(*pte);
801063cf:	8b 00                	mov    (%eax),%eax
801063d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801063d6:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801063dc:	76 b2                	jbe    80106390 <loaduvm+0x30>
      n = PGSIZE;
801063de:	bf 00 10 00 00       	mov    $0x1000,%edi
801063e3:	eb ad                	jmp    80106392 <loaduvm+0x32>
801063e5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
801063e8:	31 c0                	xor    %eax,%eax
}
801063ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ed:	5b                   	pop    %ebx
801063ee:	5e                   	pop    %esi
801063ef:	5f                   	pop    %edi
801063f0:	5d                   	pop    %ebp
801063f1:	c3                   	ret    
801063f2:	66 90                	xchg   %ax,%ax
      return -1;
801063f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063fc:	5b                   	pop    %ebx
801063fd:	5e                   	pop    %esi
801063fe:	5f                   	pop    %edi
801063ff:	5d                   	pop    %ebp
80106400:	c3                   	ret    
      panic("loaduvm: address should exist");
80106401:	83 ec 0c             	sub    $0xc,%esp
80106404:	68 8f 71 10 80       	push   $0x8010718f
80106409:	e8 32 9f ff ff       	call   80100340 <panic>
    panic("loaduvm: addr must be page aligned");
8010640e:	83 ec 0c             	sub    $0xc,%esp
80106411:	68 30 72 10 80       	push   $0x80107230
80106416:	e8 25 9f ff ff       	call   80100340 <panic>
8010641b:	90                   	nop

8010641c <allocuvm>:
{
8010641c:	55                   	push   %ebp
8010641d:	89 e5                	mov    %esp,%ebp
8010641f:	57                   	push   %edi
80106420:	56                   	push   %esi
80106421:	53                   	push   %ebx
80106422:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106425:	8b 7d 10             	mov    0x10(%ebp),%edi
80106428:	85 ff                	test   %edi,%edi
8010642a:	0f 88 b8 00 00 00    	js     801064e8 <allocuvm+0xcc>
  if(newsz < oldsz)
80106430:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106433:	0f 82 9f 00 00 00    	jb     801064d8 <allocuvm+0xbc>
  a = PGROUNDUP(oldsz);
80106439:	8b 45 0c             	mov    0xc(%ebp),%eax
8010643c:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106442:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106448:	39 75 10             	cmp    %esi,0x10(%ebp)
8010644b:	0f 86 8a 00 00 00    	jbe    801064db <allocuvm+0xbf>
80106451:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106454:	8b 7d 10             	mov    0x10(%ebp),%edi
80106457:	eb 40                	jmp    80106499 <allocuvm+0x7d>
80106459:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
8010645c:	50                   	push   %eax
8010645d:	68 00 10 00 00       	push   $0x1000
80106462:	6a 00                	push   $0x0
80106464:	53                   	push   %ebx
80106465:	e8 f2 dc ff ff       	call   8010415c <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010646a:	5a                   	pop    %edx
8010646b:	59                   	pop    %ecx
8010646c:	6a 06                	push   $0x6
8010646e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106474:	50                   	push   %eax
80106475:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010647a:	89 f2                	mov    %esi,%edx
8010647c:	8b 45 08             	mov    0x8(%ebp),%eax
8010647f:	e8 b4 fb ff ff       	call   80106038 <mappages>
80106484:	83 c4 10             	add    $0x10,%esp
80106487:	85 c0                	test   %eax,%eax
80106489:	78 69                	js     801064f4 <allocuvm+0xd8>
  for(; a < newsz; a += PGSIZE){
8010648b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106491:	39 f7                	cmp    %esi,%edi
80106493:	0f 86 9b 00 00 00    	jbe    80106534 <allocuvm+0x118>
    mem = kalloc();
80106499:	e8 96 bd ff ff       	call   80102234 <kalloc>
8010649e:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801064a0:	85 c0                	test   %eax,%eax
801064a2:	75 b8                	jne    8010645c <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801064a4:	83 ec 0c             	sub    $0xc,%esp
801064a7:	68 ad 71 10 80       	push   $0x801071ad
801064ac:	e8 6f a1 ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
801064b1:	83 c4 10             	add    $0x10,%esp
801064b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801064b7:	39 45 10             	cmp    %eax,0x10(%ebp)
801064ba:	74 2c                	je     801064e8 <allocuvm+0xcc>
801064bc:	89 c1                	mov    %eax,%ecx
801064be:	8b 55 10             	mov    0x10(%ebp),%edx
801064c1:	8b 45 08             	mov    0x8(%ebp),%eax
801064c4:	e8 f3 fb ff ff       	call   801060bc <deallocuvm.part.0>
      return 0;
801064c9:	31 ff                	xor    %edi,%edi
}
801064cb:	89 f8                	mov    %edi,%eax
801064cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d0:	5b                   	pop    %ebx
801064d1:	5e                   	pop    %esi
801064d2:	5f                   	pop    %edi
801064d3:	5d                   	pop    %ebp
801064d4:	c3                   	ret    
801064d5:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801064d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801064db:	89 f8                	mov    %edi,%eax
801064dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e0:	5b                   	pop    %ebx
801064e1:	5e                   	pop    %esi
801064e2:	5f                   	pop    %edi
801064e3:	5d                   	pop    %ebp
801064e4:	c3                   	ret    
801064e5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801064e8:	31 ff                	xor    %edi,%edi
}
801064ea:	89 f8                	mov    %edi,%eax
801064ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ef:	5b                   	pop    %ebx
801064f0:	5e                   	pop    %esi
801064f1:	5f                   	pop    %edi
801064f2:	5d                   	pop    %ebp
801064f3:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
801064f4:	83 ec 0c             	sub    $0xc,%esp
801064f7:	68 c5 71 10 80       	push   $0x801071c5
801064fc:	e8 1f a1 ff ff       	call   80100620 <cprintf>
  if(newsz >= oldsz)
80106501:	83 c4 10             	add    $0x10,%esp
80106504:	8b 45 0c             	mov    0xc(%ebp),%eax
80106507:	39 45 10             	cmp    %eax,0x10(%ebp)
8010650a:	74 0d                	je     80106519 <allocuvm+0xfd>
8010650c:	89 c1                	mov    %eax,%ecx
8010650e:	8b 55 10             	mov    0x10(%ebp),%edx
80106511:	8b 45 08             	mov    0x8(%ebp),%eax
80106514:	e8 a3 fb ff ff       	call   801060bc <deallocuvm.part.0>
      kfree(mem);
80106519:	83 ec 0c             	sub    $0xc,%esp
8010651c:	53                   	push   %ebx
8010651d:	e8 82 bb ff ff       	call   801020a4 <kfree>
      return 0;
80106522:	83 c4 10             	add    $0x10,%esp
80106525:	31 ff                	xor    %edi,%edi
}
80106527:	89 f8                	mov    %edi,%eax
80106529:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652c:	5b                   	pop    %ebx
8010652d:	5e                   	pop    %esi
8010652e:	5f                   	pop    %edi
8010652f:	5d                   	pop    %ebp
80106530:	c3                   	ret    
80106531:	8d 76 00             	lea    0x0(%esi),%esi
80106534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106537:	89 f8                	mov    %edi,%eax
80106539:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010653c:	5b                   	pop    %ebx
8010653d:	5e                   	pop    %esi
8010653e:	5f                   	pop    %edi
8010653f:	5d                   	pop    %ebp
80106540:	c3                   	ret    
80106541:	8d 76 00             	lea    0x0(%esi),%esi

80106544 <deallocuvm>:
{
80106544:	55                   	push   %ebp
80106545:	89 e5                	mov    %esp,%ebp
80106547:	8b 45 08             	mov    0x8(%ebp),%eax
8010654a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010654d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
80106550:	39 d1                	cmp    %edx,%ecx
80106552:	73 08                	jae    8010655c <deallocuvm+0x18>
}
80106554:	5d                   	pop    %ebp
80106555:	e9 62 fb ff ff       	jmp    801060bc <deallocuvm.part.0>
8010655a:	66 90                	xchg   %ax,%ax
8010655c:	89 d0                	mov    %edx,%eax
8010655e:	5d                   	pop    %ebp
8010655f:	c3                   	ret    

80106560 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	53                   	push   %ebx
80106566:	83 ec 0c             	sub    $0xc,%esp
80106569:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
8010656c:	85 ff                	test   %edi,%edi
8010656e:	74 51                	je     801065c1 <freevm+0x61>
  if(newsz >= oldsz)
80106570:	31 c9                	xor    %ecx,%ecx
80106572:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106577:	89 f8                	mov    %edi,%eax
80106579:	e8 3e fb ff ff       	call   801060bc <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010657e:	89 fb                	mov    %edi,%ebx
80106580:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80106586:	eb 07                	jmp    8010658f <freevm+0x2f>
80106588:	83 c3 04             	add    $0x4,%ebx
8010658b:	39 de                	cmp    %ebx,%esi
8010658d:	74 23                	je     801065b2 <freevm+0x52>
    if(pgdir[i] & PTE_P){
8010658f:	8b 03                	mov    (%ebx),%eax
80106591:	a8 01                	test   $0x1,%al
80106593:	74 f3                	je     80106588 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106595:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106598:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010659d:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801065a2:	50                   	push   %eax
801065a3:	e8 fc ba ff ff       	call   801020a4 <kfree>
801065a8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801065ab:	83 c3 04             	add    $0x4,%ebx
801065ae:	39 de                	cmp    %ebx,%esi
801065b0:	75 dd                	jne    8010658f <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
801065b2:	89 7d 08             	mov    %edi,0x8(%ebp)
}
801065b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b8:	5b                   	pop    %ebx
801065b9:	5e                   	pop    %esi
801065ba:	5f                   	pop    %edi
801065bb:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801065bc:	e9 e3 ba ff ff       	jmp    801020a4 <kfree>
    panic("freevm: no pgdir");
801065c1:	83 ec 0c             	sub    $0xc,%esp
801065c4:	68 e1 71 10 80       	push   $0x801071e1
801065c9:	e8 72 9d ff ff       	call   80100340 <panic>
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <setupkvm>:
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	56                   	push   %esi
801065d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801065d5:	e8 5a bc ff ff       	call   80102234 <kalloc>
801065da:	89 c6                	mov    %eax,%esi
801065dc:	85 c0                	test   %eax,%eax
801065de:	74 40                	je     80106620 <setupkvm+0x50>
  memset(pgdir, 0, PGSIZE);
801065e0:	50                   	push   %eax
801065e1:	68 00 10 00 00       	push   $0x1000
801065e6:	6a 00                	push   $0x0
801065e8:	56                   	push   %esi
801065e9:	e8 6e db ff ff       	call   8010415c <memset>
801065ee:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801065f1:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
801065f6:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801065f9:	8b 4b 08             	mov    0x8(%ebx),%ecx
801065fc:	29 c1                	sub    %eax,%ecx
801065fe:	83 ec 08             	sub    $0x8,%esp
80106601:	ff 73 0c             	pushl  0xc(%ebx)
80106604:	50                   	push   %eax
80106605:	8b 13                	mov    (%ebx),%edx
80106607:	89 f0                	mov    %esi,%eax
80106609:	e8 2a fa ff ff       	call   80106038 <mappages>
8010660e:	83 c4 10             	add    $0x10,%esp
80106611:	85 c0                	test   %eax,%eax
80106613:	78 17                	js     8010662c <setupkvm+0x5c>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106615:	83 c3 10             	add    $0x10,%ebx
80106618:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010661e:	75 d6                	jne    801065f6 <setupkvm+0x26>
}
80106620:	89 f0                	mov    %esi,%eax
80106622:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106625:	5b                   	pop    %ebx
80106626:	5e                   	pop    %esi
80106627:	5d                   	pop    %ebp
80106628:	c3                   	ret    
80106629:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
8010662c:	83 ec 0c             	sub    $0xc,%esp
8010662f:	56                   	push   %esi
80106630:	e8 2b ff ff ff       	call   80106560 <freevm>
      return 0;
80106635:	83 c4 10             	add    $0x10,%esp
80106638:	31 f6                	xor    %esi,%esi
}
8010663a:	89 f0                	mov    %esi,%eax
8010663c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010663f:	5b                   	pop    %ebx
80106640:	5e                   	pop    %esi
80106641:	5d                   	pop    %ebp
80106642:	c3                   	ret    
80106643:	90                   	nop

80106644 <kvmalloc>:
{
80106644:	55                   	push   %ebp
80106645:	89 e5                	mov    %esp,%ebp
80106647:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010664a:	e8 81 ff ff ff       	call   801065d0 <setupkvm>
8010664f:	a3 a4 56 11 80       	mov    %eax,0x801156a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106654:	05 00 00 00 80       	add    $0x80000000,%eax
80106659:	0f 22 d8             	mov    %eax,%cr3
}
8010665c:	c9                   	leave  
8010665d:	c3                   	ret    
8010665e:	66 90                	xchg   %ax,%ax

80106660 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106666:	31 c9                	xor    %ecx,%ecx
80106668:	8b 55 0c             	mov    0xc(%ebp),%edx
8010666b:	8b 45 08             	mov    0x8(%ebp),%eax
8010666e:	e8 51 f9 ff ff       	call   80105fc4 <walkpgdir>
  if(pte == 0)
80106673:	85 c0                	test   %eax,%eax
80106675:	74 05                	je     8010667c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106677:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010667a:	c9                   	leave  
8010667b:	c3                   	ret    
    panic("clearpteu");
8010667c:	83 ec 0c             	sub    $0xc,%esp
8010667f:	68 f2 71 10 80       	push   $0x801071f2
80106684:	e8 b7 9c ff ff       	call   80100340 <panic>
80106689:	8d 76 00             	lea    0x0(%esi),%esi

8010668c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010668c:	55                   	push   %ebp
8010668d:	89 e5                	mov    %esp,%ebp
8010668f:	57                   	push   %edi
80106690:	56                   	push   %esi
80106691:	53                   	push   %ebx
80106692:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106695:	e8 36 ff ff ff       	call   801065d0 <setupkvm>
8010669a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010669d:	85 c0                	test   %eax,%eax
8010669f:	0f 84 96 00 00 00    	je     8010673b <copyuvm+0xaf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801066a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801066a8:	85 db                	test   %ebx,%ebx
801066aa:	0f 84 8b 00 00 00    	je     8010673b <copyuvm+0xaf>
801066b0:	31 ff                	xor    %edi,%edi
801066b2:	eb 40                	jmp    801066f4 <copyuvm+0x68>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801066b4:	50                   	push   %eax
801066b5:	68 00 10 00 00       	push   $0x1000
801066ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066bd:	05 00 00 00 80       	add    $0x80000000,%eax
801066c2:	50                   	push   %eax
801066c3:	56                   	push   %esi
801066c4:	e8 17 db ff ff       	call   801041e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801066c9:	5a                   	pop    %edx
801066ca:	59                   	pop    %ecx
801066cb:	53                   	push   %ebx
801066cc:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066d2:	50                   	push   %eax
801066d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066d8:	89 fa                	mov    %edi,%edx
801066da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066dd:	e8 56 f9 ff ff       	call   80106038 <mappages>
801066e2:	83 c4 10             	add    $0x10,%esp
801066e5:	85 c0                	test   %eax,%eax
801066e7:	78 5f                	js     80106748 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
801066e9:	81 c7 00 10 00 00    	add    $0x1000,%edi
801066ef:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801066f2:	76 47                	jbe    8010673b <copyuvm+0xaf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801066f4:	31 c9                	xor    %ecx,%ecx
801066f6:	89 fa                	mov    %edi,%edx
801066f8:	8b 45 08             	mov    0x8(%ebp),%eax
801066fb:	e8 c4 f8 ff ff       	call   80105fc4 <walkpgdir>
80106700:	85 c0                	test   %eax,%eax
80106702:	74 5f                	je     80106763 <copyuvm+0xd7>
    if(!(*pte & PTE_P))
80106704:	8b 18                	mov    (%eax),%ebx
80106706:	f6 c3 01             	test   $0x1,%bl
80106709:	74 4b                	je     80106756 <copyuvm+0xca>
    pa = PTE_ADDR(*pte);
8010670b:	89 d8                	mov    %ebx,%eax
8010670d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
80106715:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
8010671b:	e8 14 bb ff ff       	call   80102234 <kalloc>
80106720:	89 c6                	mov    %eax,%esi
80106722:	85 c0                	test   %eax,%eax
80106724:	75 8e                	jne    801066b4 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106726:	83 ec 0c             	sub    $0xc,%esp
80106729:	ff 75 e0             	pushl  -0x20(%ebp)
8010672c:	e8 2f fe ff ff       	call   80106560 <freevm>
  return 0;
80106731:	83 c4 10             	add    $0x10,%esp
80106734:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010673b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010673e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106741:	5b                   	pop    %ebx
80106742:	5e                   	pop    %esi
80106743:	5f                   	pop    %edi
80106744:	5d                   	pop    %ebp
80106745:	c3                   	ret    
80106746:	66 90                	xchg   %ax,%ax
      kfree(mem);
80106748:	83 ec 0c             	sub    $0xc,%esp
8010674b:	56                   	push   %esi
8010674c:	e8 53 b9 ff ff       	call   801020a4 <kfree>
      goto bad;
80106751:	83 c4 10             	add    $0x10,%esp
80106754:	eb d0                	jmp    80106726 <copyuvm+0x9a>
      panic("copyuvm: page not present");
80106756:	83 ec 0c             	sub    $0xc,%esp
80106759:	68 16 72 10 80       	push   $0x80107216
8010675e:	e8 dd 9b ff ff       	call   80100340 <panic>
      panic("copyuvm: pte should exist");
80106763:	83 ec 0c             	sub    $0xc,%esp
80106766:	68 fc 71 10 80       	push   $0x801071fc
8010676b:	e8 d0 9b ff ff       	call   80100340 <panic>

80106770 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106776:	31 c9                	xor    %ecx,%ecx
80106778:	8b 55 0c             	mov    0xc(%ebp),%edx
8010677b:	8b 45 08             	mov    0x8(%ebp),%eax
8010677e:	e8 41 f8 ff ff       	call   80105fc4 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106783:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106785:	89 c2                	mov    %eax,%edx
80106787:	83 e2 05             	and    $0x5,%edx
8010678a:	83 fa 05             	cmp    $0x5,%edx
8010678d:	75 0d                	jne    8010679c <uva2ka+0x2c>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010678f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106794:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106799:	c9                   	leave  
8010679a:	c3                   	ret    
8010679b:	90                   	nop
    return 0;
8010679c:	31 c0                	xor    %eax,%eax
}
8010679e:	c9                   	leave  
8010679f:	c3                   	ret    

801067a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	83 ec 0c             	sub    $0xc,%esp
801067a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801067ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
801067af:	85 c9                	test   %ecx,%ecx
801067b1:	74 65                	je     80106818 <copyout+0x78>
801067b3:	89 fb                	mov    %edi,%ebx
801067b5:	eb 37                	jmp    801067ee <copyout+0x4e>
801067b7:	90                   	nop
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801067b8:	89 f2                	mov    %esi,%edx
801067ba:	2b 55 0c             	sub    0xc(%ebp),%edx
    if(n > len)
801067bd:	8d ba 00 10 00 00    	lea    0x1000(%edx),%edi
801067c3:	3b 7d 14             	cmp    0x14(%ebp),%edi
801067c6:	76 03                	jbe    801067cb <copyout+0x2b>
801067c8:	8b 7d 14             	mov    0x14(%ebp),%edi
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801067cb:	52                   	push   %edx
801067cc:	57                   	push   %edi
801067cd:	53                   	push   %ebx
801067ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801067d1:	29 f1                	sub    %esi,%ecx
801067d3:	01 c8                	add    %ecx,%eax
801067d5:	50                   	push   %eax
801067d6:	e8 05 da ff ff       	call   801041e0 <memmove>
    len -= n;
    buf += n;
801067db:	01 fb                	add    %edi,%ebx
    va = va0 + PGSIZE;
801067dd:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801067e3:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801067e6:	83 c4 10             	add    $0x10,%esp
801067e9:	29 7d 14             	sub    %edi,0x14(%ebp)
801067ec:	74 2a                	je     80106818 <copyout+0x78>
    va0 = (uint)PGROUNDDOWN(va);
801067ee:	8b 75 0c             	mov    0xc(%ebp),%esi
801067f1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801067f7:	83 ec 08             	sub    $0x8,%esp
801067fa:	56                   	push   %esi
801067fb:	ff 75 08             	pushl  0x8(%ebp)
801067fe:	e8 6d ff ff ff       	call   80106770 <uva2ka>
    if(pa0 == 0)
80106803:	83 c4 10             	add    $0x10,%esp
80106806:	85 c0                	test   %eax,%eax
80106808:	75 ae                	jne    801067b8 <copyout+0x18>
      return -1;
8010680a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010680f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106812:	5b                   	pop    %ebx
80106813:	5e                   	pop    %esi
80106814:	5f                   	pop    %edi
80106815:	5d                   	pop    %ebp
80106816:	c3                   	ret    
80106817:	90                   	nop
  return 0;
80106818:	31 c0                	xor    %eax,%eax
}
8010681a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010681d:	5b                   	pop    %ebx
8010681e:	5e                   	pop    %esi
8010681f:	5f                   	pop    %edi
80106820:	5d                   	pop    %ebp
80106821:	c3                   	ret    
