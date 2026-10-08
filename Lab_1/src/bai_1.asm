	.data
str1: 	.asciiz "Chao ban! Ban la sinh vien nam thu may?\n"
str2: 	.asciiz " Hihi, minh la sinh vien nam thu 1 ^-^\n"
# Khai báo vùng nhớ có nhãn 'str1' và 'str2' để lưu giá trị 2 chuỗi (có null terminator).

	.text
li 	$v0, 4 		# Sử dụng dịch vụ xuất chuỗi.
la 	$a0, str1 	# Lưu địa chỉ vùng nhớ chứa chuỗi đầu tiên vào $a0 để xuất ra chuỗi này trước.
syscall 		# Kích hoạt dịch vụ hệ thống.

la	$a0, str2	# Lưu địa chỉ vùng nhớ chứa chuỗi thứ hai vào $a0 để xuất ra chuỗi này tiếp theo.
syscall