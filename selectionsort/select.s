.code32
.text

.globl _start
_start:
 
  .extern printf

  pushl %ebp
  movl %esp, %ebp

  movl 4(%ebp), %eax 
  
  cmp $2, %eax
  jne argCount  

  pushl %eax
  pushl $msg2
  call printf
  add $8, %esp

  movl 12(%ebp), %esi
  call atoi
 
  movl %eax, %edi
  leal 4(,%edi,4), %eax
  subl %eax, %esp

  testl %edi, %edi
  jle L1

  movl %esp, %esi
  xorl %ebx, %ebx

scanLoop:
  pushl %esi
  pushl $formatin
  addl $1, %ebx
  addl $4, %esi
  call scanf
  add $8, %esp
  cmpl %ebx, %edi
  jne scanLoop
  jmp unsortPrintLoopInit
L1:
  addl %eax,%esp

  call exit
unsortPrintLoopInit:
  movl $0, %ebx
  movl %esp, %esi
  cmpl %ebx, %edi
  jne unsortPrintLoop
unsortPrintLoop:
  pushl (%esi)
  pushl $msg5
  addl $1, %ebx
  addl $4, %esi
  call printf
  
  add $8, %esp

  cmpl %ebx, %edi
  jne unsortPrintLoop
  jmp sortInit
  
sortInit:
  movl %edi, %esi 
  movl %esp, %ebx 

  dec %esi

sortOuterLoop:
  movl (%ebx, %esi,4), %eax
  movl %esi, %ecx 
  leal -1(%esi), %edx 

sortInnerLoop:
  cmpl (%ebx,%edx,4),%eax 
  cmovl %edx,%ecx
  cmovl (%ebx,%edx,4), %eax
  
  dec %edx
  jns sortInnerLoop
  
  movl (%ebx,%esi,4),%edx
  movl %eax, (%ebx,%esi,4)
  movl %edx, (%ebx,%ecx,4)

  dec %esi
  jne sortOuterLoop
  
  movl $0, %ebx
  movl %esp, %esi
  cmpl %ebx, %edi
  jne sortPrintLoop
sortPrintLoop:
  pushl (%esi)
  pushl $msg6
  addl $1, %ebx
  addl $4, %esi
  call printf
  
  add $8, %esp

  cmpl %ebx, %edi
  jne sortPrintLoop
  call exit

argCount:

  pushl $msg3
  call printf
  add $4, %esp
  call exit

atoi:
  pushl %ebx
  pushl %edx
  pushl %esi
  
  mov $0, %eax
nxchr:
  mov $0, %ebx
  mov (%esi), %bl
  inc %esi

  cmp $'0', %bl
  jb inval
  cmp $'9', %bl
  ja inval

  sub $'0', %bl
  movl $0xa, %ecx
  mull %ecx
  add %ebx, %eax
  jmp nxchr
inval:
  pop %esi
  pop %edx
  pop %ebx
  ret

.data

  msg2: .asciz "Arg Count = %d\n"
  msg3: .asciz "This program takes 1 argument -> sizeOfArray\n"
  msg5: .asciz "Unsorted Array Value = %d\n"
  msg6: .asciz "Sorted Array Value =%d\n"
  formatin: .asciz "%d"
