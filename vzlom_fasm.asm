use16

org			100h

INPUT_BUF_SIZE 		equ 30
INPUT_BUF_MAX_LEN   equ 28

start:	
		mov  dx, welcome
		call write_string

		call get_pass

		mov  bx, pass
		xor  cx, cx
		mov  cl, [pass_len]
		call check_pass

	start_check:
		cmp  ax, 1
		jne  start_fail

	start_sucess:
		mov  dx, sucess
		jmp  start_write

	start_fail:
		mov  dx, fail

	start_write:
		call write_string

		jmp  exit

;dx - string
write_string:
		push ax

		mov  ax, 0900h
		int  21h

		pop  ax
		ret

;return:
;dx - buf with pass
get_pass:
		push ax bx

		sub  sp, INPUT_BUF_SIZE-10
		mov  bx, sp
		mov  [bx], byte INPUT_BUF_MAX_LEN
		mov  dx, bx

		mov  ax, 0a00h
		int  21h

		add  sp, INPUT_BUF_SIZE-10

		pop  bx ax
		ret

;dx - buf with pass, input
;bx - buf with pass, correct
;cx - len buf with pass
;
;return:
;ax - 1, if not correct pass, 0 if correct
check_pass:
		push di si
		mov  di, dx

		xor  ax, ax
		mov  al, [di+1]

	check_pass_check_len:
			cmp  al, cl
			je   check_pass_correct_len

	check_pass_incorrect_pass:
			pop  si di
			mov  ax, 0
			ret

	check_pass_correct_len:

		xor  si, si
		add  di, 2

	check_pass_check_loop:
			mov  al, [si+bx]
			cmp  al, [di]
			jne  check_pass_incorrect_pass

			inc  si
			inc  di
			cmp  si, cx
			je   check_pass_correct_pass
			jmp  check_pass_check_loop

	check_pass_correct_pass:
			pop  si di
			mov  ax, 1
			ret

exit:		
		mov  ax, 4c00h
		int  21h

welcome			db 'Hello, write password', 0ah, '$'
sucess      	db 0ah, 'Sucess!$'
fail 			db 0ah, 'LOOOOOOOOOOOOOOH, try again!$'

pass        	db 'DOCHKA'
pass_len    	db $ - pass

