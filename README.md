# Mini Payroll & Attendance

### ตาม requirement

- **Employee CRUD** — list, create, edit, delete, show พนักงาน (ชื่อ ตำแหน่ง เงินเดือน)
- **บันทึกการเข้างาน** — เช็คอิน / เช็คเอาท์ พร้อม rule: 1 ครั้งต่อวัน, เช็คเอาท์ต้องหลังเช็คอิน, คำนวณ OT อัตโนมัติเมื่อทำงานเกิน 8 ชม.
- **คำนวณเงินเดือน** — แสดงในหน้า Employee Show: วันทำงาน, OT hours, OT pay, ภาษีแบบขั้นบันได, net pay
- **Unit tests** — model specs และ request specs ครอบคลุม business logic หลัก
- **Tailwind CSS UI** — design อ่านง่าย

### เพิ่มเติมจาก requirement

- **Month/year filter** ใน attendance index และ payroll summary

## AI Tools ที่ใช้

**Claude** (Anthropic) ผ่าน **Claude Code**

ใช้ในส่วน:
- สร้าง model, controller, migration และ view
- ออกแบบ UI ด้วย Tailwind CSS
- เขียน unit test และ request spec
- Code review และแก้ไขปัญหาด้านความถูกต้องและ security

## ฟีเจอร์

- **จัดการพนักงาน** — เพิ่ม ดู แก้ไข และลบข้อมูลพนักงาน
- **บันทึกการเข้างาน** — เช็คอินและเช็คเอาท์พร้อมคำนวณ OT อัตโนมัติ
- **สรุปเงินเดือน** — แสดง breakdown รายเดือนของเงินเดือน OT ภาษี และเงินได้สุทธิ

## Tech Stack

- **Ruby** 3.3.6
- **Rails** 8.1.3
- **PostgreSQL** 17
- **Tailwind CSS** — จัดสไตล์ UI
- **Hotwire (Turbo + Stimulus)** — การนำทางแบบ SPA โดยไม่โหลดหน้าใหม่ทั้งหมด
- **RSpec** — เขียน unit test และ request spec
- **SimpleCov** — รายงาน test coverage
- **Docker** — รัน PostgreSQL ผ่าน Docker Compose

### การเข้างาน
- เช็คอินได้ 1 ครั้งต่อวันต่อพนักงาน
- เวลาเช็คเอาท์ต้องหลังเวลาเช็คอิน
- คำนวณ OT อัตโนมัติจากชั่วโมงที่ทำงานเกิน 8 ชั่วโมง

### เงินเดือน (รายเดือน)
| รายการ | สูตร |
|--------|------|
| OT Pay | ชั่วโมง OT × (เงินเดือน ÷ 30 ÷ 8) |
| ภาษี | 0% เมื่อเงินเดือน ≤ 30,000 / 5% ส่วนที่เกิน 30,000–50,000 / 10% ส่วนที่เกิน 50,000 |
| เงินได้สุทธิ | เงินเดือน + OT Pay − ภาษี |

> ภาษีคำนวณจากเงินเดือนพื้นฐานเท่านั้น — OT Pay ไม่ถูกนำมาคิดภาษี

## เริ่มต้นใช้งาน

### สิ่งที่ต้องติดตั้ง

- Ruby 3.3.6
- Docker (สำหรับ PostgreSQL)

### ขั้นตอนการติดตั้ง

1. Clone repository และติดตั้ง dependencies:

```bash
bundle install
```

2. สร้างไฟล์ environment และกรอกค่าที่ต้องการ:

ไฟล์ `.env` ควรมีเนื้อหาดังนี้:

```
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
DB_NAME=mini_payroll_attendance_development
DB_PORT=5432
DB_HOST=localhost
```

3. เริ่ม PostgreSQL ด้วย Docker:

```bash
docker-compose up -d
```

4. สร้างและ migrate ฐานข้อมูล:

```bash
rails db:create db:migrate
```

5. เริ่ม development server:

```bash
bin/dev
```

เปิดเบราว์เซอร์ที่ `http://localhost:3000`

## การรัน Test

```bash
bundle exec rspec
```

ดูรายงาน coverage หลังจากรัน test:

```bash
open coverage/index.html
```
