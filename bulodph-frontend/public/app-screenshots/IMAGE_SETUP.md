# HPA Plus App Screenshots Setup

To display the HPA Plus app screenshots throughout the landing page, copy these 5 images into this folder with the exact filenames below.

## Required Images

Copy from: `C:\Users\Cocotantan\.cursor\projects\c-Users-Cocotantan-Downloads-HPA-plus\assets\`

| Destination Filename | Source Filename |
|----------------------|-----------------|
| `app-login-staff.png` | `c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_1-67e0f24eb7565-14bad46a-a9a3-4537-bfcd-7681a719b0be.png` |
| `app-phones-duo.png` | `c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_2-67e0c9ee241c6-43b31494-f084-4464-bd47-904b819111ea.png` |
| `app-tablet-phone.png` | `c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_3-67e1e6a95d39b-scaled-4e247a4e-b175-48fc-bfdb-3df38d6cf8cf.png` |
| `app-schedule.png` | `c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_4-67e0fafe16a61-8ae3d5b3-ccde-4a1e-8551-13385caf9c22.png` |
| `app-clients-progress.png` | `c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_5-67e0e91eba95b-scaled-3c04e092-4463-4833-8f69-1183457ca87c.png` |

## Where They Appear

- **Hero**: `app-tablet-phone.png` – Dashboard mockup (Client List + Treatment History)
- **Features**: Each feature block shows its matching app screenshot
- **App Showcase**: `app-login-staff.png`, `app-schedule.png` – Mobile app phones
- **CTA**: `app-login-staff.png` – Compact app preview

## Quick Copy (PowerShell)

Run from the project root:

```powershell
$src = "C:\Users\Cocotantan\.cursor\projects\c-Users-Cocotantan-Downloads-HPA-plus\assets"
$dest = ".\public\app-screenshots"

Copy-Item "$src\c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_1-67e0f24eb7565-14bad46a-a9a3-4537-bfcd-7681a719b0be.png" "$dest\app-login-staff.png"
Copy-Item "$src\c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_2-67e0c9ee241c6-43b31494-f084-4464-bd47-904b819111ea.png" "$dest\app-phones-duo.png"
Copy-Item "$src\c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_3-67e1e6a95d39b-scaled-4e247a4e-b175-48fc-bfdb-3df38d6cf8cf.png" "$dest\app-tablet-phone.png"
Copy-Item "$src\c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_4-67e0fafe16a61-8ae3d5b3-ccde-4a1e-8551-13385caf9c22.png" "$dest\app-schedule.png"
Copy-Item "$src\c__Users_Cocotantan_AppData_Roaming_Cursor_User_workspaceStorage_824c43919e641c74843940049b17ff80_images_5-67e0e91eba95b-scaled-3c04e092-4463-4833-8f69-1183457ca87c.png" "$dest\app-clients-progress.png"
```
