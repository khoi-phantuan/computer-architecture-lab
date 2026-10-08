	.data
input_str: .asciiz 	# Khai báo vùng nhớ lưu chuỗi có null terminator, dán nhãn 'input_str' cho nó - không khởi tạo giá trị cho vùng nhớ này

	.text
li $v0, 8 		# Nạp giá trị tức thời 8 vào thanh ghi v0 (sử dụng dịch vụ "đọc chuỗi")

# Dịch vụ "đọc chuỗi": 
# - Đọc X byte dữ liệu mà người dùng nhập vào từ bàn phím, 
# - Lưu nó vào vùng nhớ có địa chỉ được lưu trong thanh ghi a0,
# - Với X là giá trị trong thanh ghi a1.

la $a0, input_str 	# Nạp địa chỉ của vùng nhớ vừa khai báo vào thanh ghi a0

li $a1, 100 		# Nạp giá trị tức thời 100 vào thanh ghi a1 (ta muốn assembler đọc tối đa 100 byte ký tự mà ta nhập vào)

syscall 		# Kích hoạt dịch vụ

li $v0, 4		# Lưu giá trị tức thời 4 vào thanh ghi v0 (dùng dịch vụ "in chuỗi")
syscall			# Kích hoạt dịch vụ