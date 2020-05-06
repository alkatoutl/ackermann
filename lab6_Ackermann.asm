.data
	prompt1: .asciiz "Ackermann function A(x,y)\nValue for x: "
	prompt2: .asciiz "Value for y: "
	error: .asciiz "Integers cannot be negative.\n"
	result: .asciiz "The result is: "

.text
	main:       
    		la $a0,prompt1           
    		li $v0,4            
    		syscall             

                        	
    		li $v0,5            
    		syscall             
    		move $t0,$v0   # copy x to $t0 
		blez $t0, Error 
                        
    		la $a0,prompt2           
    		li $v0,4           
    		syscall             
	
                        	
   		li $v0,5            
    		syscall             
    		move $t1, $v0  #copy y to $t1
    		blez $t1, Error
    		
    		move $a1,$t1        # copy y to $a1
    		move $a0,$t0        # copy x to $a0

    		jal Ackermann       
               #$v0 contains the result after

                       		 	
   		move $a1,$v0        
   		
   		la $a0, result
   		li $v0, 4
   		syscall
   		
   		move $a0, $a1
   		
    		li $v0,1           
    		syscall             

                        
    		li $v0,10           
    		syscall   
    		
   	Error:
		li $v0, 4
		la $a0, error
		syscall
		j main	          
    
	Ackermann:
		sub $sp,$sp,8       # make room on the stack for 2 variables (4 bytes each)
   		sw $s0,4($sp)       # store old $s0 at $sp+4
   		sw $ra,0($sp)       # store old $ra at $sp+0
    		bgtz $a0, case1     # If x > 0, go to case 1
               # Case for x = 0:
    		add $v0,$a1,1       # result = y+1
    		j End          
    	
	case1:
    		bgtz $a1,case2     # if y > 0, go to case 2
               # Case for x>0 and y=0:
    		sub $a0,$a0,1       # x= x-1
    		li $a1,1            # y =1
    		jal Ackermann       # x-1 in $a0 and 1 in $a1, call Ackermann
    		j End         
    		
	case2:
               # Case for x>0 and y>0:
    		move $s0,$a0        # copy x to $s0
    		sub $a1,$a1,1       # y = y-1
    		jal Ackermann       
    		move $a1,$v0        # y = result of A(x, y-1)
    		sub $a0,$s0,1       # x = x-1
    		jal Ackermann       

	End:         
    		lw $s0,4($sp)       
    		lw $ra,0($sp)       
    		add $sp,$sp,8       
    		jr $ra              