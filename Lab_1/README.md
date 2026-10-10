# Lab 1 — Giới thiệu phần mềm MARS và lập trình hợp ngữ MIPS

## Mục tiêu
Trong bài lab này, mình đã được làm quen lại với cách lập trình hợp ngữ (assembly) cho kiến trúc MIPS của CPU, cũng như cách sử dụng phần mềm MARS để thực hiện điều đó.

---

## Phần 1: Thực hành theo hướng dẫn

### 1.1. Các lệnh MIPS cơ bản
Dưới đây là chức năng của một số lệnh MIPS cơ bản:

| Lệnh | Chức năng |
| :--- | :--- |
| `add $t0, $t1, $t2` | Cộng giá trị trong thanh ghi t1 và t2 rồi lưu kết quả vào thanh ghi t0 - **CÓ kiểm tra tràn**. |
| `addi $t0, $t1, imm` | Cộng giá trị trong thanh ghi t1 và giá trị immediate (số nguyên - 16 bit) rồi lưu kết quả vào thanh ghi t0 - **CÓ kiểm tra tràn**. Immediate được mở rộng bằng bit dấu. |
| `addu $t0, $t1, $t2` | Cộng giá trị trong thanh ghi t1 và t2 rồi lưu kết quả vào thanh ghi t0 - **KHÔNG kiểm tra tràn**. |
| `addiu $t0, $t1, imm` | Cộng giá trị trong thanh ghi t1 và giá trị immediate (16 bit) rồi lưu kết quả vào thanh ghi t0 - **KHÔNG kiểm tra tràn**. |
| `sub $t0, $t1, $t2` | Trừ giá trị trong thanh ghi t1 cho giá trị trong thanh ghi t2 rồi lưu kết quả vào thanh ghi t0 - **CÓ kiểm tra tràn**. |
| `subu $t0, $t1, $t2` | Trừ giá trị trong thanh ghi t1 cho giá trị trong thanh ghi t2 rồi lưu kết quả vào thanh ghi t0 - **KHÔNG kiểm tra tràn**. |
| `and $t0, $t1, $t2` | Lưu kết quả phép AND giữa giá trị trong thanh ghi t1 và t2 vào thanh ghi t0. |
| `andi $t0, $t1, imm` | Lưu kết quả phép AND giữa giá trị trong thanh ghi t1 và giá trị imm (16 bit) vào thanh ghi t0. Immediate được mở rộng bằng bit 0. |
| `or $t0, $t1, $t2` | Lưu kết quả phép OR giữa giá trị trong thanh ghi t1 và t2 vào thanh ghi t0. |
| `nor $t0, $t1, $t2` | Lưu kết quả phép NOR giữa giá trị trong thanh ghi t1 và t2 vào thanh ghi t0. |
| `lw $t0, off($t1)` | Nạp 1 word (4 byte) được lưu tại vùng nhớ có địa chỉ là `<giá trị lưu trong thanh ghi t1 + offset>` vào thanh ghi t0. Địa chỉ này phải chia hết cho 4. |
| `sw $t0, off($t1)` | Lưu 1 word (4 byte) trong thanh ghi t0 vào vùng nhớ có địa chỉ là `<giá trị lưu trong thanh ghi t1 + offset>`. Địa chỉ này phải chia hết cho 4. |
| `slt $t0, $t1, $t2` | Nếu giá trị trong thanh ghi t1 bé hơn giá trị trong thanh ghi t2, giá trị trong thanh ghi t0 sẽ bằng 1. Nếu không, giá trị trong thanh ghi t0 sẽ bằng 0. |
| `slti $t0, $t1, imm` | Nếu giá trị trong thanh ghi t1 bé hơn giá trị imm (16 bit), giá trị trong thanh ghi t0 sẽ bằng 1. Nếu không, giá trị trong thanh ghi t0 sẽ bằng 0. |
| `sltu $t0, $t1, $t2` | Giống câu lệnh `slt` nhưng so sánh **KHÔNG dấu**. |
| `sltiu $t0, $t1, imm` | Giống câu lệnh `slti` nhưng so sánh **KHÔNG dấu**. |
| `syscall` | Kích hoạt dịch vụ hệ thống (thường là input và output) thông qua việc đặt giá trị cho các thanh ghi hệ thống (v0, a0, a1, a2, f12). |

***Một số lưu ý:***

**1.** Trường `immediate` trong mọi lệnh MIPS chỉ chứa 16 bit (tức đây chỉ là số 16 bit), nhưng giá trị trong thanh ghi dùng để tính toán với immediate thì lại là số 32 bit -> Phải mở rộng bit cho số immediate. Có hai cách mở rộng:
- **Dùng bit dấu (sign-extended)**: gán giá trị cho 16 bit cao trong immediate mở rộng giống hệt giá trị của bit 15 (bit dấu) trong immediate gốc.
- **Dùng bit 0 (zero-extended)**: gán 16 bit cao trong immediate mở rộng bằng 0.

Mỗi lệnh sẽ dùng một kiểu tùy theo tính chất của nó. Ví dụ: `addi/addiu/slti/sltiu` dùng sign-extended, còn `andi` dùng zero-extended.

**2.** Nếu `immediate` cần tốn hơn 16 bit để biểu diễn, assembler sẽ phải **thực hiện thêm các lệnh ngầm** để nạp từng nửa của giá trị immediate vào rồi mới xử lý. Ví dụ:

![Khi immediate vượt quá 16 bit](<images/khi immediate vuot qua 16 bit.png>)

Như ta thấy, để thực hiện lệnh add với số immediate vượt quá 16 bit này (số 100000 có dấu cần 18 bit để biểu diễn), assembler phải thực hiện thêm 2 lệnh phụ khác. Ngoài ra vẫn còn nhiều trường hợp khác mà assembler phải tách lệnh gốc thành nhiều lệnh con để thực hiện tuần tự.

**3.** Có hai kiểu tràn số sẽ xuất hiện khi assembler biên dịch code và CPU chạy chương trình:
- Hằng số của lệnh quá lớn so với kích thước biểu diễn (32 bit) -> Assembler **tự cắt bớt phần bit cao dư ra** khi biên dịch, không báo lỗi.
- Hằng số của lệnh nằm trong kích thước cho phép, nhưng sau khi tính toán số học với chúng thì kết quả lại vượt quá kích thước biểu diễn (32 bit) -> CPU **báo lỗi (sinh ra exception) và dừng chương trình**.

**4.** Chú thích "with overflow" của một lệnh có nghĩa là **"CPU có kiểm tra tràn số khi thực thi lệnh này"** - nếu kết quả tràn thì CPU báo lỗi và dừng chương trình. Với "without overflow" thì ngược lại.

### 1.2. Mô phỏng ví dụ

**Ví dụ 1:**

```mips
        .data
var1:   .word   23

        .text
__start:
        lw      $t0, var1
        li      $t1, 5
        sw      $t1, var1
```

- Mô phỏng:

![Mô phỏng ví dụ 1](images/mo%20phong%20vd%201.png)

- Ý nghĩa: Nạp word tại vùng nhớ có nhãn ‘var1’ vào thanh ghi t0, và nạp giá trị số trực tiếp vào thanh ghi t1. Sau đó lưu word trong thanh ghi t1 vào vùng nhớ có nhãn ‘var1’.

***Một số lưu ý:***
- Địa chỉ vùng nhớ liên quan đến lệnh lw và sw phải chia hết cho 4.
- Lệnh lw và sw gốc (và cả các lệnh load/store khác) chỉ làm việc với địa chỉ của vùng nhớ liên quan, không làm việc với nhãn/tên biến:
  - Khi ta viết `lw $t0, var1` (lệnh giả); điều đó có nghĩa là "nạp word được lưu trong vùng nhớ có nhãn là "var1" vào thanh ghi t0".
  - Còn khi ta viết `lw $t0, X($t1)`; điều đó có nghĩa là "nạp word được lưu trong vùng nhớ có địa chỉ chỉ bằng <giá trị trong thanh ghi t1 + X byte>" (nói dễ hiểu là lấy giá trị được lưu trong t1 ra, xem nó như một địa chỉ, rồi "đi tiếp" qua X byte (ô nhớ) kể từ địa chỉ đó - vùng nhớ được trỏ vào sau bước này chính là vùng nhớ mà chương trình dùng để nạp giá trị vào).

**Ví dụ 2:**

```mips
        .data
array1: .space  12
        
        .text
__start:
        la      $t0, array1
        li      $t1, 5
        sw      $t1, ($t0)
        li      $t1, 13
        sw      $t1, 4($t0)
        li      $t1, -7
        sw      $t1, 8($t0)
```

- Mô phỏng: 

![Mô phỏng ví dụ 2](images/mo%20phong%20vd%202.png)

- Ý nghĩa: 

![Ý nghĩa ví dụ 2](images/y%20nghia%20vd%202.png)

**Ví dụ 3:**

```mips
li      $v0, 5

syscall
```

- Mô phỏng: 

Ban đầu, $v0 lưu số 5 (số hiệu dịch vụ):
![Mô phỏng ví dụ 3 - 1](images/mo%20phong%20vd%203%20-%201.png)

Sau khi người dùng nhập vào số nguyên, $v0 lưu số đó (phải đảm bảo nhập đúng giá trị hợp lệ -  số nguyên và kích thước biểu diễn không quá 32 bit, nếu không CPU sẽ báo lỗi):
![Mô phỏng ví dụ 3 - 2](images/mo%20phong%20vd%203%20-%202.png)

- Ý nghĩa:

![Ý nghĩa ví dụ 3](images/y%20nghia%20vd%203.png)

**Ví dụ 4:**

```mips
        .data
string1: .asciiz "Print this.\n"

        .text
main:
        li      $v0, 4
        la      $a0, string1
        syscall
```

- Mô phỏng:

![Mô phỏng ví dụ 4](images/mo%20phong%20vd%204.png)

- Ý nghĩa: Ta thấy, trong data segment, vùng nhớ trải dài từ ô có địa chỉ 0x10010000 đến ô có địa chỉ 0x1001000b đang lưu các giá trị HEX lẫn lộn. Chúng chính là từng phần của chuỗi “Print this.\n”.

![Ý nghĩa ví dụ 4](images/y%20nghia%20vd%204.png)

---

## Phần 2: Bài tập

### 2.1. Bài 1

#### Đề bài
```
Khai báo và xuất ra cửa sổ I/O 2 chuỗi có giá trị như sau:
- Chuỗi 1: Chao ban! Ban la sinh vien nam thu may?
- Chuỗi 2: Hihi, minh la sinh vien nam thu 1 ^-^
```

#### Mình đã làm gì?
- Đầu tiên, mình khai báo 2 biến chuỗi có ký tự kết thúc "str1" và "str2" để lưu 2 chuỗi mà chương trình sẽ in ra.
- Sau đó, mình dùng dịch vụ "print string" (số hiệu: 4) của hệ thống bằng cách nạp giá trị tức thời 4 vào thanh ghi v0.
- Trong dịch vụ này, thanh ghi a0 sẽ lưu địa chỉ vùng nhớ chứa chuỗi cần xuất ra. Mình nạp địa chỉ của biến "str1" (nói đúng hơn là "vùng nhớ có nhãn 'str1'"), rồi kích hoạt dịch vụ bằng `syscall`. Chuỗi thứ nhất sẽ được in ra cửa sổ I/O.
- Sau đó, mình làm lại tương tự: nạp địa chỉ vùng nhớ có nhãn "str2" vào thanh ghi a0, rồi kích hoạt dịch vụ bằng `syscall`. Chuỗi thứ hai được in ra màn hình ngay sau đó.

#### Code

[Bài 1](src/bai_1.asm)

---

### 2.2. Bài 2

#### Đề bài
```
Biểu diễn của 2 chuỗi trên dưới bộ nhớ là gì?
```

#### Trả lời

- Biểu diễn của 2 chuỗi trên dưới bộ nhớ là dãy bit nhị phân ứng với mã ASCII (số nhị phân 8 bit) của từng ký tự trong chuỗi, nối tiếp nhau từ ký tự đầu đến ký tự cuối. 
- Mỗi word trong bộ nhớ sẽ lưu dữ liệu của một nhóm 4 ký tự (ứng với 4 byte dữ liệu của nó).
- Đây là cách mà CPU lưu chuỗi vào bộ nhớ (ví dụ chuỗi "Xin chao"):
  1. Đặt ký tự null terminator ('\0') vào cuối chuỗi.
  2. Lưu mã ASCII của từng ký tự trong chuỗi (số nhị phân - 8 bit) vào từng byte bộ nhớ theo đúng thứ tự xuất hiện của chúng.
  3. Khi MARS hiển thị dữ liệu chuỗi được lưu trong bộ nhớ, nó sẽ chia toàn bộ chuỗi thành các word (nhóm 32 bit - 4 byte - 4 ký tự) cho người dùng dễ theo dõi.
  4. Tuy nhiên, ta sẽ thấy **thứ tự của các ký tự trong mỗi word bị đảo,** vì: 
      - Data segment của MARS cần hiển thị dữ liệu được lưu trong word dưới dạng một chuỗi 32 bit thống nhất thay vì từng nhóm 8 bit rời.
      - Và theo quy ước little endian (MARS chạy mặc định), nhóm bit ở địa chỉ thấp nhất chính là nhóm bit có trọng số thấp nhất trong chuỗi. 
      - Vậy nên, khi xem dữ liệu được lưu trong word ứng với nhóm "Xin ", ta sẽ thấy dữ liệu này được hiển thị dưới dạng " niX" thay vào đó.
  5. Ví dụ:
      
      ![](images/cach%20cpu%20luu%20chuoi%20vao%20bo%20nho%20-%20ascii.png)  

      - Chuỗi mình nhập vào là "Xin chao, minh la sinh vien Ky thuat may tinh". Nhóm 4 ký tự đầu tiên là "Xin ".
      - CPU lưu từng nhóm 8 bit ứng với từng ký tự vào từng byte bộ nhớ theo đúng thứ tự xuất hiện của chúng trong nhóm.
      - Khi MARS hiển thị dữ liệu được lưu trong word này, thứ tự các ký tự trong nhóm đã bị đảo ngược lại (" niX" thay vì "Xin ").
      - Ta có thể xem dữ liệu chuỗi được lưu trong từng word dưới dạng ký tự gốc, số thập phân hoặc số thập lục phân bằng cách tùy chỉnh lựa chọn trong mục 'Settings'.

      ![](images/cach%20cpu%20luu%20chuoi%20vao%20bo%20nho%20-%20hex.png)

      ![](images/cach%20cpu%20luu%20chuoi%20vao%20bo%20nho%20-%20dec.png)

---

### 2.3. Bài 3

#### Đề bài
```
Xuất ra lại đúng chuỗi đã nhập.
```

#### Mình đã làm gì?
- Khai báo một vùng nhớ dùng để lưu chuỗi có ký tự kết thúc. Dán nhãn "input_str" cho nó, nhưng không khởi tạo giá trị ban đầu (vì giá trị của nó sẽ là chuỗi mà user nhập vào).
- Nạp giá trị 8 vào thanh ghi v0 để dùng dịch vụ "read string".
- Dịch vụ này sẽ đọc chuỗi X byte dữ liệu mà người dùng nhập vào từ bàn phím, lưu nó vào vùng nhớ có địa chỉ được lưu trong thanh ghi a0, với X là giá trị trong thanh ghi a1.
- Vậy nên, mình đã nạp giá trị 100 (một giới hạn đủ lớn) vào thanh ghi a1 và nạp địa chỉ vùng nhớ "input_str" vào thanh ghi a0, rồi thực hiện syscall.
- Sau đó, người dùng có thể nhập chuỗi tại cửa sổ I/O. Sau khi người dùng nhấn Enter, chương trình sẽ chạy tiếp. Mình lại nạp giá trị 4 vào thanh ghi v0 để dùng dịch vụ "print string", rồi thực hiện syscall để chương trình in ra chuỗi vừa được nhập vào.

#### Code

[Bài 3](src/bai_3.asm)

---

### 2.4. Bài 4

#### Đề bài

```
Nhập vào 2 số nguyên, sau đó xuất tổng của 2 số nguyên này.
```

#### Mình đã làm gì?

- Đầu tiên, mình nạp số 5 vào thanh ghi v0 để dùng dịch vụ "read integer".
- Dịch vụ này sẽ đọc số nguyên mà người dùng nhập vào (nhấn Enter là kết thúc việc đọc), lưu nó vào thanh ghi v0.
- Mình thực hiện syscall để kích hoạt dịch vụ và nhập vào số nguyên thứ nhất. Sau đó dùng lệnh addi để cộng giá trị trong thanh ghi v0 với số 0 (tức là giữ nguyên) rồi lưu kết quả vào thanh ghi t1 (mục đích chính của cách làm này là để nạp giá trị trong một thanh ghi vào một thanh ghi khác theo cách đơn giản nhất).
- Mình nạp lại số 5 vào $v0 để dùng lại dịch vụ (vì lúc này $v0 đang lưu số nguyên mà ban nãy mình nhập vào), rồi cũng thực hiện syscall và addi để nhập số nguyên thứ hai và lưu nó vào thanh ghi t2.
- Sau đó, mình dùng lệnh add để cộng giá trị trong 2 thanh ghi t1 và t2 (2 số nguyên) lại và lưu kết quả vào thanh ghi a0.
- Cuối cùng, mình nạp số 1 vào $v0 để dùng dịch vụ "print integer" - in số nguyên ra cửa sổ I/O. Trong dịch vụ này, $a0 sẽ lưu số nguyên cần in ra màn hình - đó chính là lý do lúc nãy mình dùng luôn a0 làm thanh ghi đích để lưu kết quả tính toán.

#### Code

[Bài 4](src/bai_4.asm)

---

## Khó khăn và cách giải quyết

**1. Chuỗi trong Data Segment hiển thị bị đảo ngược (Bài 2).**  
Nhập vào "Xin chao..." nhưng MARS hiển thị nội dung trong word đầu tiên là " niX" - bị đảo ngược so với kỳ vọng. Mình khá khó hiểu với chi tiết này lúc đầu. Sau khi đổi cách hiển thị sang hex và đối chiếu với mã ASCII, mình mới biết là dữ liệu trong bộ nhớ vẫn đúng thứ tự, chỉ là MARS gom 4 byte thành 1 word rồi hiển thị theo little endian.

**2. Nhầm giữa nhãn và địa chỉ khi dùng lw/sw (Ví dụ 1, 2).**  
Ban đầu mình thắc mắc không biết lw và sw có thể làm việc với tên biến hay không. Sau khi tìm hiểu về cách hoạt động của 2 lệnh thì mới biết là có. Tuy nhiên đó không phải là lệnh gốc:
- `lw $t0, var1` *(đây là lệnh giả)*
- `lw $t0, off($t1)` *(đây mới là lệnh gốc)*

Cách làm việc gốc rễ với địa chỉ của lệnh lw/sw là dùng giá trị địa chỉ đã được lưu trong một thanh ghi khác - có offset.

**3. Hằng số immediate vượt 16 bit.**  
Lệnh `add` với số 100000 trong MARS bị tách thành thêm 2 lệnh phụ, trong
khi mình chỉ viết 1 lệnh. Mình nhận ra điều này sau khi quan sát cột `Basics` trong màn hình chạy chương trình.

## Mình đã học được gì?

- **Phân biệt lệnh thật và lệnh giả.** Có những lệnh mình chỉ viết một dòng, nhưng assembler phải tách ra thành nhiều lệnh nhỏ (nạp nhãn, nạp hằng số lớn). Nên khi đếm lệnh hay đọc kết quả mô phỏng, phải nhìn cả phần đã dịch ra.
- **Assembler và CPU làm hai việc khác nhau.** Assembler dịch code, còn lỗi tràn số xảy ra lúc CPU thực thi lệnh. Lệnh có `u` thì CPU không kiểm tra tràn.
- **Bộ nhớ đánh địa chỉ theo byte.** Một word là 4 byte nên địa chỉ lw/sw phải chia hết cho 4, và offset cũng tính bằng byte (đó là lý do ví dụ 2 dùng 0, 4, 8). Chuỗi thì mỗi ký tự một byte, kết thúc bằng null terminator.
- **Syscall có quy ước chung về thanh ghi** ($v0 là số hiệu và kết quả, $a0 là tham số). Vì thanh ghi dùng chung, phải tính trước dữ liệu đi đâu. Ví dụ ở Bài 4 mình đặt luôn tổng vào $a0 để khỏi tốn thêm bước chép.