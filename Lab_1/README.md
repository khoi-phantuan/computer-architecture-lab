# Lab 1 — Giới thiệu phần mềm MARS và lập trình hợp ngữ MIPS

*đang cập nhật*

<!--

## Mục tiêu

## Phần 1: Thực hành theo hướng dẫn

### 1.1. Các lệnh MIPS cơ bản

### 1.2. Mô phỏng ví dụ

---

## Phần 2: Bài tập

### 2.1. Bài 1

#### Đề bài

#### Mình đã làm gì?

#### Code

---

### 2.2. Bài 2

#### Đề bài

#### Mình đã làm gì?

#### Code

---

### 2.1. Bài 3

#### Đề bài

#### Mình đã làm gì?

#### Code

---

### 2.1. Bài 4

#### Đề bài

#### Mình đã làm gì?

#### Code

---

## Khó khăn và cách giải quyết

## Mình đã học được gì?

## Ghi chú thô về trải nghiệm

- Trường immediate trong mọi lệnh MIPS chỉ chứa 16 bit (tức đây chỉ là số 16 bit), nhưng giá trị trong thanh ghi dùng để tính toán với immediate thì lại là số 32 bit -> Phải mở rộng bit cho giá trị immediate. Có hai cách mở rộng:
  - Dùng bit dấu (sign-extended): gán giá trị cho 16 bit cao trong immediate mở rộng giống hệt giá trị bit đầu tiên (bit dấu) trong immediate gốc.
  - Dùng bit 0 (zero-extended): gán 16 bit cao trong immediate mở rộng bằng 0.

  Mỗi lệnh sẽ dùng một kiểu.

- Nếu immediate cần tốn hơn 16 bit để biểu diễn, assembler sẽ phải thực hiện thêm các lệnh ngầm để nạp từng nửa của giá trị immediate vào rồi mới xử lý.  
  Ví dụ:
  
  *(hình: khi immediate vuot qua 16 bit.png)*

  Ta thấy để thực hiện lệnh add với immediate vượt quá 16 bit này (số 100000 có dấu cần 18 bit để biểu diễn), assembler phải thực hiện thêm 2 lệnh phụ khác. Còn nhiều trường hợp khác (lệnh khác) mà assembler phải chia lệnh chính thành nhiều lệnh nhỏ để thực tuần tự.

- Có hai kiểu tràn số khi assembler chạy chương trình:
  - Các số nhập vào (input) quá lớn so với kích thước biểu diễn (32 bit) -> Assembler tự cắt bớt phần bit cao dư khi biên dịch, không báo lỗi.
  - Các số nhập vào (input) nằm trong kích thước cho phép, nhưng sau khi tính toán số học với chúng thì kết quả lại vượt quá kích thước biểu diễn (32 bit) -> Assembler báo lỗi (sinh ra exception) và dừng chương trình.

- Chú thích "with overflow" của một lệnh có nghĩa là "assembler có kiểm tra tràn số khi thực thi lệnh này" - nếu kết quả tràn thì CPU báo lỗi và dừng chương trình. Với "without overflow" thì ngược lại.

- Địa chỉ vùng nhớ liên quan đến lệnh lw và sw phải chia hết cho 4.

- Lệnh lw và sw (và cả các lệnh load/store khác) chỉ làm việc với địa chỉ của vùng nhớ liên quan, không làm việc với nhãn/tên biến. 
  - Khi ta viết `lw $t0, var1`; điều đó có nghĩa là "nạp word được lưu trong vùng nhớ có nhãn là "var1" vào thanh ghi t0".
  - Còn khi ta viết `lw $t0, (X)$t1`; điều đó có nghĩa là "nạp word được lưu trong vùng nhớ có địa chỉ chỉ bằng <giá trị trong thanh ghi t1 + X.4 byte>" (nói dễ hiểu là lấy giá trị được lưu trong t1 ra, xem nó như một địa chỉ, rồi "đi tiếp" qua X word kể từ địa chỉ đó - địa chỉ được trỏ vào sau bước này chính là địa chỉ cuối được dùng để load).

- Cách mà CPU lưu chuỗi vào bộ nhớ (ví dụ chuỗi "Xin chao"):
  1. Chia chuỗi gốc ra thành từng nhóm 4 ký tự (nhóm "Xin ", "chao", '\0') - các ký tự cuối bị lẻ ra vẫn sẽ được gom thành 1 nhóm.
  2. Lưu mã ASCII của từng ký tự trong mỗi nhóm (số nhị phân - 8 bit) vào từng byte bộ nhớ theo đúng thứ tự xuất hiện của các ký tự trong nhóm.
  3. Sau cùng, ta có một chuỗi 32 bit nhị phân ứng với nhóm này (bằng đúng kích thước của một word trong bộ xử lý MIPS này). Tức là word này lưu phần "Xin " của chuỗi.
  4. **Nhưng khi MARS hiển thị dữ liệu chuỗi được lưu trong từng word ra cho người dùng xem, ta sẽ thấy thứ tự của chúng bị đảo.**  
      - Data segment của MARS cần hiển thị dữ liệu được lưu trong word dưới dạng một chuỗi 32 bit thống nhất thay vì từng nhóm 8 bit rời.
      - Và theo quy ước little endian, nhóm bit ở địa chỉ thấp nhất chính là nhóm bit có trọng số thấp nhất trong chuỗi. 
      - Vậy nên, khi xem dữ liệu được lưu trong word ứng với nhóm "Xin ", ta sẽ thấy dữ liệu này được hiển thị dưới dạng " niX".
  5. Ví dụ:
      
      (cach cpu luu chuoi vao bo nho - ascii.png)  

      - Chuỗi mình nhập vào là "Xin chao, minh la sinh vien Ky thuat may tinh". Nhóm 4 ký tự đầu tiên là "Xin ".
      - CPU lưu từng nhóm 8 bit ứng với từng ký tự vào từng byte bộ nhớ theo đúng thứ tự xuất hiện của chúng trong nhóm.
      - Khi MARS hiển thị dữ liệu được lưu trong word này, thứ tự các ký tự trong nhóm đã bị đảo ngược lại (" niX" thay vì "Xin ").
      - Ta có thể xem dữ liệu chuỗi được lưu trong từng word dưới dạng ký tự gốc, số thập phân hoặc số thập lục phân bằng cách tùy chỉnh lựa chọn trong mục 'Settings'.

      (cach cpu luu chuoi vao bo nho - hex.png)  

      (cach cpu luu chuoi vao bo nho - dec.png)  

