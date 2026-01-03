# Import Templates

## 1. Doctor Import Template (doctor_template.xlsx)
Please create an Excel file with the following columns (Header in Row 1):

| Name | Gender | DeptId | Title | Phone | Email | Specialty |
|------|--------|--------|-------|-------|-------|-----------|
| Zhang San | M | 1 | Chief Physician | 13800138000 | zhangsan@example.com | Cardiology expert |
| Li Si | F | 2 | Attending Physician | 13900139000 | lisi@example.com | Pediatrics |

**Note:**
- **DeptId**: Must be a valid Department ID from the database.
- **Gender**: 'M' or 'F' (or '男'/'女' depending on your system configuration).
- **Password**: Default password will be set to '123456'.

## 2. Schedule Import Template (schedule_template.xlsx)
Please create an Excel file with the following columns (Header in Row 1):

| DoctorID | Date | TimeSlot | MaxPatients |
|----------|------|----------|-------------|
| 20230001 | 2023-11-01 | 09:00-09:30 | 5 |
| 20230001 | 2023-11-01 | 09:30-10:00 | 5 |

**Note:**
- **DoctorID**: Must be an existing Doctor ID (8 digits).
- **Date**: Format should be recognized by Excel as a Date (e.g., yyyy-MM-dd).
- **TimeSlot**: String format like "09:00-09:30".
