@echo off
color f0
chcp 65001 >nul
title DISM+ by Lê Vũ Phúc Nguyên
:main
cls
echo.===============================================================================
echo.				DISM+ - Main Menu
echo.===============================================================================
echo.
echo.				[1] Get Image Info
echo.
echo.				[2] Apply Image
echo.
echo.				[3] Capture Image
echo.
echo.				[4] Export Image
echo.
echo.				[5] Mount Image
echo.
echo.				[6] Unmount Image
echo.
echo.				[7] Modify Image
echo.
echo.
echo.				[S] Setup Windows
echo.
echo.				[X] Thoát
echo.
echo.===============================================================================
echo.
choice /c:1234567SX /n /m "Lựa chọn của bạn: "
if errorlevel 9 exit
if errorlevel 8 goto :setup
if errorlevel 7 goto :modify
if errorlevel 6 goto :unmount
if errorlevel 5 goto :mount
if errorlevel 4 goto :export
if errorlevel 3 goto :capture
if errorlevel 2 goto :apply
if errorlevel 1 goto :info

:info
cls
echo.===============================================================================
echo.				Get Image Info
echo.===============================================================================
echo.
choice /c:TC /n /m "Bạn muốn xem thông tin tổng quát của file hay thông tin chi tiết của một Index? ('T'ổng quát/'C'hi tiết) "
if errorlevel 2 goto :detailinfo
if errorlevel 1 goto :fullinfo

:fullinfo
set /p imagefile=Nhập đường dẫn đến file cần xem thông tin: 
dism /get-imageinfo /imagefile:%imagefile%
goto :outtro

:detailinfo
set /p imagefile=Nhập đường dẫn đến file cần xem thông tin: 
set /p index=Nhập số Index: 
dism /get-imageinfo /imagefile:%imagefile% /index:%index%
goto :outtro

:apply
cls
echo.===============================================================================
echo.				Apply Image
echo.===============================================================================
echo.
set /p imagefile=Nhập đường dẫn đến file cần bung: 
set /p index=Nhập số Index: 
set /p applydir=Nhập đường dẫn đến nơi bung file: 
dism /apply-image /imagefile:%imagefile% /index:%index% /applydir:%applydir%
goto :outtro

:capture
cls
echo.===============================================================================
echo.				Capture Image
echo.===============================================================================
echo.
set /p imagefile=Nhập đường dẫn đến file cần tạo: 
set /p capturedir=Nhập đường dẫn đến nơi cần capture: 
set /p name=Nhập tên Index: 
choice /c:MFN /n /m "Chọn mức độ nén ('M'ax/'F'ast/'N'one): "
if errorlevel 3 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:none
if errorlevel 2 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:fast
if errorlevel 1 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:max
goto :outtro

:export
cls
echo.===============================================================================
echo.				Export Image
echo.===============================================================================
echo.
echo.-------------------------------------------------------------------------------
echo. Lưu ý: 
echo. Nếu file đích là một file có sẵn thì file gốc và file đích phải có cùng mức độ nén
echo. Tùy chọn mức độ nén sẽ không có hiệu lực nếu file đích là một file có sẵn
echo. Nếu dùng compress là recovery thì file đích phải có đuôi mở rộng là .esd
echo.-------------------------------------------------------------------------------
echo.
set /p sourceimagefile=Nhập đường dẫn đến file gốc: 
set /p sourceindex=Nhập số Index cần export của file gốc: 
set /p destinationimagefile=Nhập đường dẫn đến file đích: 
choice /c:MFNR /n /m "Chọn mức độ nén ('M'ax/'F'ast/'N'one/'R'ecovery): "
if errorlevel 4 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:recovery
if errorlevel 3 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:none
if errorlevel 2 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:fast
if errorlevel 1 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:max
goto :outtro

:mount
cls
echo.===============================================================================
echo.				Mount Image
echo.===============================================================================
echo.
set /p imagefile=Nhập đường dẫn đến file cần mount: 
set /p index=Nhập số Index cần mount: 
set /p mountdir=Nhập đường dẫn đến nơi cần mount ra: 
dism /mount-image /imagefile:%imagefile% /index:%index% /mountdir:%mountdir%
goto :outtro

:unmount
cls
echo.===============================================================================
echo.				Unmount Image
echo.===============================================================================
echo.
set /p mountdir=Nhập đường dẫn đến nơi đã được mount: 
choice /c:CD /n /m "Bạn có muốn lưu các thay đổi không? ('C'ommit/'D'iscard) "
if errorlevel 2 dism /unmount-image /mountdir:%mountdir% /discard
if errorlevel 1 dism /unmount-image /mountdir:%mountdir% /commit
goto :outtro

:modify
cls
echo.===============================================================================
echo.				Modify Image
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn muốn sửa lỗi HĐH đang chạy hay HĐH khác trên máy? (HĐH đang 'c'hạy/HĐH 'k'hác) "
if errorlevel 2 (
set /p image=Nhập đường dẫn đến nơi chứa hệ điều hành cần modify: 
set oo=image:%image%
)
if errorlevel 1 set oo=online
goto :modifymenu

:modifymenu
cls
echo.===============================================================================
echo.				   Modify Image
echo.===============================================================================
echo.
echo.				   [1] Health
echo.
echo.				   [2] Cleanup
echo.
echo.				   [3] Drivers
echo.
echo.				   [4] Packages
echo.
echo.-------------------------------------------------------------------------------
echo.
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :packages
if errorlevel 3 goto :drivers
if errorlevel 2 goto :cleanup
if errorlevel 1 goto :health

:health
cls
echo.===============================================================================
echo.				   Image Health
echo.===============================================================================
echo.
echo.				  [1] Check Health
echo.
echo.				  [2] Scan Health
echo.
echo.				  [3] Restore Health
echo.
echo.-------------------------------------------------------------------------------
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 dism /%oo% /cleanup-image /restorehealth
if errorlevel 2 dism /%oo% /cleanup-image /scanhealth
if errorlevel 1 dism /%oo% /cleanup-image /checkhealth
goto :outtro

:cleanup
cls
echo.===============================================================================
echo.				  Image Cleanup
echo.===============================================================================
echo.
echo.			    [1] Analyze Component Store
echo.
echo.			    [2] Start Component Cleanup
echo.
echo.-------------------------------------------------------------------------------
echo.
choice /c:12 /n /m "Lựa chọn của bạn: "
if errorlevel 2 goto :startcomponentcleanup
if errorlevel 1 dism /%oo% /cleanup-image /analyzecomponentstore
choice /c:CK /n /m "Bạn có muốn tiếp tục Start Component Cleanup không? ('C'ó/'K'hông) "
if errorlevel 2 goto :outtro
if error level 1 goto :startcomponentcleanup

:startcomponentcleanup
cls
echo.===============================================================================
echo.				Start Component Cleanup
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn có muốn Reset Base không? ('C'ó/'K'hông) "
if errorlevel 2 dism /%oo% /cleanup-image /startcomponentcleanup
if errorlevel 1 goto :resetbase
goto :outtro

:resetbase
echo.-------------------------------------------------------------------------------
echo. 		Cảnh báo: Lệnh này sẽ xóa hết các bản sao lưu cập nhật
echo.			nên bạn không thể gỡ cài đặt bản cập nhật
echo.-------------------------------------------------------------------------------
echo.
choice /c:CK /n /m "Bạn có muốn tiếp tục? ('C'ó/'K'hông) "
if errorlevel 2 goto :outtro
if errorlevel 1 dism /%oo% /cleanup-image /startcomponentcleanup /resetbase
goto :outtro

:drivers
cls
echo.===============================================================================
echo.				 Image Drivers
echo.===============================================================================
echo.
echo.				[1] Get Drivers
echo.
echo.				[2] Export Driver
echo.
echo.				[3] Add Driver
echo.
echo.				[4] Remove Driver
echo.
echo.-------------------------------------------------------------------------------
echo.
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :removedriver
if errorlevel 3 goto :adddriver
if errorlevel 2 goto :exportdriver
if errorlevel 1 dism /%oo% /get-drivers
goto :outtro

:exportdriver
set /p destination=Nhập đường dẫn đến nơi xuất driver: 
dism /%oo% /export-driver /destination:%destination%
goto :outtro

:adddriver
set /p driver=Nhập đường dẫn đến thư mục chứa driver: 
choice /c:CK /n /m "Bạn có muốn thêm driver trong những thư mục con không? ('C'ó/'K'hông) "
if errorlevel 2 dism /%oo% /add-driver /driver:%driver%
if errorlevel 1 dism /%oo% /add-driver /driver:%driver% /recurse
goto :outtro

:removedriver
set /p driver=Nhập tên driver cần xóa: 
dism /%oo% /remove-driver /driver:%driver%
goto :outtro

:packages
cls
echo.===============================================================================
echo.				 Image Packages
echo.===============================================================================
echo.
echo.				[1] Get Packages
echo.
echo.				[2] Add Package
echo.
echo.				[3] Remove Package
echo.
echo.-------------------------------------------------------------------------------
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 goto :removepackage
if errorlevel 2 goto :addpackage
if errorlevel 1 dism /%oo% /get-packages
goto :outtro

:addpackage
set /p packagepath=Nhập đường dẫn đến file Package (.cab) cần thêm: 
dism /%oo% /add-package /packagepath:%packagepath%
goto :outtro

:removepackage
set /p packagename=Nhập tên của Package cần xóa: 
dism /%oo% /remove-package /packagename:%packagename%
goto :outtro

:setup
cls
echo.===============================================================================
echo.				Setup Windows
echo.===============================================================================
echo.
set /p imagefile=Nhập đường dẫn đến file install.wim trong bộ cài Windows: 
set /p index=Nhập số Index của phiên bản cần cài: 
set /p applydir=Nhập ký tự của phân vùng chứa Windows (bao gồm dấu ":"): 
set /p s=Nhập ký tự của phân vùng Boot (bao gồm dấu ":"): 
choice /c:LU2 /n /m "Bạn muốn cài Windows theo chuẩn nào? ('L'egacy BIOS/'U'EFI/Cả '2' chuẩn) "
if errorlevel 3 set f=All
if errorlevel 2 set f=UEFI
if errorlevel 1 set f=BIOS
dism /apply-image /imagefile:%imagefile% /index:%index% /applydir:%applydir%
bcdboot %applydir%\Windows /s %s% /f %f%
goto :outtro

:outtro
choice /c:CK /n /m "Bạn có muốn thoát? ('C'ó/'Không) "
if errorlevel 2 goto :main
if errorlevel 1 exit
