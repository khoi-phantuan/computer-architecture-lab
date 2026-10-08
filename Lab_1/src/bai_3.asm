	.text
li $v0, 5 		# Nạp giá trị tức thời 5 vào $v0 để sử dụng dịch vụ "đọc số nguyên"
			# Dịch vụ "đọc số nguyên": Đọc số nguyên người dùng nhập vào và lưu vào thanh ghi v0
syscall 		# Kích hoạt dịch vụ để đọc số nguyên thứ nhất user nhập vào
addi $t1, $v0, 0 	# Lấy giá trị trong $v0 (số nguyên vừa đọc), cộng 0 (giữ nguyên) và lưu kết quả vào $t1


li $v0, 5 		# Nạp lại giá trị vào $v0 để chuẩn bị cho lần sử dụng dịch vụ tiếp theo 
			# (vì giá trị trong thanh ghi đã bị đổi sau khi user nhập số nguyên vào trước đó)
syscall 		# Kích hoạt dịch vụ để đọc số nguyên thứ nhất user nhập vào
addi $t2, $v0, 0	# Lưu giá trị vừa đọc được vào $t2


add $a0, $t1, $t2 	# Lưu kết quả phép cộng giá trị trong $t1 và $t2 vào $a0 
			# (a0 chính là thanh ghi chứa giá trị cần in ra trong dịch vụ "in số nguyên")			
li $v0, 1		# Nạp giá trị tức thời 1 vào $v0 để sử dụng dịch vụ "in số nguyên"
			# Dịch vụ "in số nguyên": In giá trị trong thanh ghi a0 ra màn hình
			
syscall			# Kích hoạt dịch vụ để in tổng 2 số nguyên ra màn hình