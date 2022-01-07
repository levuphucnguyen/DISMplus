@echo off
color f0
chcp 65001 >nul
title DISM+ by Lê Vũ Phúc Nguyên
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
echo.				[X] Thoát
echo.
echo.===============================================================================
echo.
choice /c:1234567X /n /m "Lựa chọn của bạn: "
if errorlevel 8 exit
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
choice /c:TC /n /m "Bạn muốn xem thông tin tổng quát của file hay thông tin chi tiết của một Index? (T:Tổng quát/C:Chi tiết) "
if errorlevel 2 goto :detailinfo
if errorlevel 1 goto :fullinfo

:fullinfo
set /p imagefile=Vui lòng điền đường dẫn đến file cần xem thông tin: 
dism /get-imageinfo /imagefile:%imagefile%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:detailinfo
set /p imagefile=Vui lòng điền đường dẫn đến file cần xem thông tin: 
set /p index=Vui lòng điền số Index: 
dism /get-imageinfo /imagefile:%imagefile% /index:%index%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:apply
cls
echo.===============================================================================
echo.				Apply Image
echo.===============================================================================
echo.
set /p imagefile=Vui lòng điền đường dẫn đến file cần bung: 
set /p index=Vui lòng điền số Index: 
set /p applydir=Vui lòng điền đường dẫn đến nơi bung file: 
dism /apply-image /imagefile:%imagefile% /index:%index% /applydir:%applydir%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:capture
cls
echo.===============================================================================
echo.				Capture Image
echo.===============================================================================
echo.
set /p imagefile=Vui lòng điền đường dẫn đến file cần tạo: 
set /p capturedir=Vui lòng điền đường dẫn đến nơi cần capture: 
set /p name=Vui lòng điền tên Index: 
choice /c:MFN /n /m "Vui lòng chọn mức độ nén (M:max/F:fast/N:none): "
if errorlevel 3 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:none
if errorlevel 2 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:fast
if errorlevel 1 dism /capture-image /imagefile:%imagefile% /capturedir:%capturedir% /name:%name% /compress:max
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:export
cls
echo.===============================================================================
echo.				Export Image
echo.===============================================================================
echo.
echo. Lưu ý: Nếu file đích là một file có sẵn thì file gốc và file đích phải có cùng mức độ nén
echo.        Tùy chọn mức độ nén sẽ không có hiệu lực nếu file đích là một file có sẵn
echo.        Nếu dùng compress là recovery thì file đích phải có đuôi mở rộng là .esd
echo.
set /p sourceimagefile=Vui lòng điền đường dẫn đến file gốc: 
set /p sourceindex=Vui lòng điền số Index cần export của file gốc: 
set /p destinationimagefile=Vui lòng điền đường dẫn đến file đích: 
choice /c:MFNR /n /m "Vui lòng chọn mức độ nén (M:max/F:fast/N:none/R:recovery): "
if errorlevel 4 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:recovery
if errorlevel 3 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:none
if errorlevel 2 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:fast
if errorlevel 1 dism /export-image /sourceimagefile:%sourceimagefile% /sourceindex:%sourceindex% /destinationimagefile:%destinationimagefile% /compress:max
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:mount
cls
echo.===============================================================================
echo.				Mount Image
echo.===============================================================================
echo.
set /p imagefile=Vui lòng điền đường dẫn đến file cần mount: 
set /p index=Vui lòng điền số Index cần mount: 
set /p mountdir=Vui lòng điền đường dẫn đến nơi cần mount ra: 
dism /mount-image /imagefile:%imagefile% /index:%index% /mountdir:%mountdir%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:unmount
cls
echo.===============================================================================
echo.				Unmount Image
echo.===============================================================================
echo.
set /p mountdir=Vui lòng điền đường dẫn đến nơi đã được mount: 
choice /c:CD /n /m "Bạn có muốn chấp nhận các thay đổi không? (C:Commit/D:Discard) "
if errorlevel 2 dism /unmount-image /mountdir:%mountdir% /discard
if errorlevel 1 dism /unmount-image /mountdir:%mountdir% /commit
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:modify
cls
echo.===============================================================================
echo.				Modify Image
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn muốn sữa lỗi HĐH đang chạy hay HĐH khác trên máy? (C:HĐH đang chạy/K:HĐH khác) "
if errorlevel 2 goto :modifyoffline
if errorlevel 1 goto :modifyonline

:modifyonline
cls
echo.===============================================================================
echo.				Modify Online Image
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
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :onlinepackages
if errorlevel 3 goto :onlinedrivers
if errorlevel 2 goto :onlinecleanup
if errorlevel 1 goto :onlinehealth

:onlinehealth
cls
echo.===============================================================================
echo.				Online Image Health
echo.===============================================================================
echo.
echo.				  [1] Check Health
echo.
echo.				  [2] Scan Health
echo.
echo.				  [3] Restore Health
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 dism /online /cleanup-image /restorehealth
if errorlevel 2 dism /online /cleanup-image /scanhealth
if errorlevel 1 dism /online /cleanup-image /checkhealth
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlinecleanup
cls
echo.===============================================================================
echo.				Online Image Cleanup
echo.===============================================================================
echo.
echo.			    [1] Analyze Component Store
echo.
echo.			    [2] Start Component Cleanup
echo.
choice /c:12 /n /m "Lựa chọn của bạn: "
if errorlevel 2 goto :onlinestartcomponentcleanup
if errorlevel 1 dism /online /cleanup-image /analyzecomponentstore
choice /c:CK /n /m "Bạn có muốn tiếp tục Start Component Cleanup không? (C:Có/K:Không) "
if errorlevel 2 exit
if error level 1 goto :onlinestartcomponentcleanup

:onlinestartcomponentcleanup
cls
echo.===============================================================================
echo.				Start Component Cleanup
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn có muốn Reset Base không? (C:Có/K:Không) "
if errorlevel 2 dism /online /cleanup-image /startcomponentcleanup
if errorlevel 1 goto :onlineresetbase
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineresetbase
echo.===============================================================================
echo. 		Cảnh báo: Lệnh này sẽ xóa hết các bản sao lưu cập nhật,
echo.			nên bạn không thể gỡ cài đặt bản cập nhật
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn có muốn tiếp tục? (C:Có/K:Không) "
if errorlevel 2 exit
if errorlevel 1 dism /online /cleanup-image /startcomponentcleanup /resetbase
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlinedrivers
cls
echo.===============================================================================
echo.				Online Image Drivers
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
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :onlineremovedriver
if errorlevel 3 goto :onlineadddriver
if errorlevel 2 goto :onlineexportdriver
if errorlevel 1 dism /online /get-drivers
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineexportdriver
set /p destination=Vui lòng điền đường dẫn đến nơi xuất driver: 
dism /online /export-driver /destination:%destination%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineadddriver
set /p driver=Vui lòng điền đường dẫn đến thư mục chứa driver: 
choice /c:CK /n /m "Bạn có muốn thêm driver trong những thư mục con không? (C:Có/K:Không) "
if errorlevel 2 dism /online /add-driver /driver:%driver%
if errorlevel 1 dism /online /add-driver /driver:%driver% /recurse
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineremovedriver
set /p driver=Vui lòng điền tên driver cần xóa: 
dism /online /remove-driver /driver:%driver%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlinepackages
cls
echo.===============================================================================
echo.				Online Image Packages
echo.===============================================================================
echo.
echo.				[1] Get Packages
echo.
echo.				[2] Add Package
echo.
echo.				[3] Remove Package
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 goto :onlineremovepackage
if errorlevel 2 goto :onlineaddpackage
if errorlevel 1 dism /online /get-packages
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineaddpackage
set /p packagepath=Vui lòng điền đường dẫn đến file Package (.cab) cần thêm: 
dism /online /add-package /packagepath:%packagepath%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:onlineremovepackage
set /p packagename=Vui lòng điền tên của Package cần xóa: 
dism /online /remove-package /packagename:%packagename%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:modifyoffline
set /p image=Vui lòng điền đường dẫn đến nơi chứa hệ điều hành cần modify: 
cls
echo.===============================================================================
echo.				Modify Offline Image
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
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :offlinepackages
if errorlevel 3 goto :offlinedrivers
if errorlevel 2 goto :offlinecleanup
if errorlevel 1 goto :offlinehealth

:offlinehealth
cls
echo.===============================================================================
echo.				Offline Image Health
echo.===============================================================================
echo.
echo.				  [1] Check Health
echo.
echo.				  [2] Scan Health
echo.
echo.				  [3] Restore Health
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 dism /image:%image% /cleanup-image /restorehealth
if errorlevel 2 dism /image:%image% /cleanup-image /scanhealth
if errorlevel 1 dism /image:%image% /cleanup-image /checkhealth
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlinecleanup
cls
echo.===============================================================================
echo.				Offline Image Cleanup
echo.===============================================================================
echo.
echo.			    [1] Analyze Component Store
echo.
echo.			    [2] Start Component Cleanup
echo.
choice /c:12 /n /m "Lựa chọn của bạn: "
if errorlevel 2 goto :offlinestartcomponentcleanup
if errorlevel 1 dism /image:%image% /cleanup-image /analyzecomponentstore
choice /c:CK /n /m "Bạn có muốn tiếp tục Start Component Cleanup không? (C:Có/K:Không) "
if errorlevel 2 exit
if error level 1 goto :offlinestartcomponentcleanup

:offlinestartcomponentcleanup
cls
echo.===============================================================================
echo.				Start Component Cleanup
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn có muốn Reset Base không? (C:Có/K:Không) "
if errorlevel 2 dism /image:%image% /cleanup-image /startcomponentcleanup
if errorlevel 1 goto :offlineresetbase
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineresetbase
echo.===============================================================================
echo. 		Cảnh báo: Lệnh này sẽ xóa hết các bản sao lưu cập nhật,
echo.			nên bạn không thể gỡ cài đặt bản cập nhật
echo.===============================================================================
echo.
choice /c:CK /n /m "Bạn có muốn tiếp tục? (C:Có/K:Không) "
if errorlevel 2 exit
if errorlevel 1 dism /image:%image% /cleanup-image /startcomponentcleanup /resetbase
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlinedrivers
cls
echo.===============================================================================
echo.				Offline Image Drivers
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
choice /c:1234 /n /m "Lựa chọn của bạn: "
if errorlevel 4 goto :offlineremovedriver
if errorlevel 3 goto :offlineadddriver
if errorlevel 2 goto :offlineexportdriver
if errorlevel 1 dism /image:%image% /get-drivers
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineexportdriver
set /p destination=Vui lòng điền đường dẫn đến nơi xuất driver: 
dism /image:%image% /export-driver /destination:%destination%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineadddriver
set /p driver=Vui lòng điền đường dẫn đến thư mục chứa driver: 
choice /c:CK /n /m "Bạn có muốn thêm driver trong thư mục con không? (C:Có/K:Không) "
if errorlevel 2 dism /image:%image% /add-driver /driver:%driver%
if errorlevel 1 dism /image:%image% /add-driver /driver:%driver% /recurse
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineremovedriver
set /p driver=Vui lòng điền tên driver cần xóa: 
dism /image:%image% /remove-driver /driver:%driver%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlinepackages
cls
echo.===============================================================================
echo.				Offline Image Packages
echo.===============================================================================
echo.
echo.				[1] Get Packages
echo.
echo.				[2] Add Package
echo.
echo.				[3] Remove Package
echo.
choice /c:123 /n /m "Lựa chọn của bạn: "
if errorlevel 3 goto :offlineremovepackage
if errorlevel 2 goto :offlineaddpackage
if errorlevel 1 dism /image:%image% /get-packages
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineaddpackage
set /p packagepath=Vui lòng điền đường dẫn đến file Package (.cab) cần thêm: 
dism /image:%image% /add-package /packagepath:%packagepath%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit

:offlineremovepackage
set /p packagename=Vui lòng điền tên của Package cần xóa: 
dism /image:%image% /remove-package /packagename:%packagename%
echo Nhấn phím bất kỳ để thoát...
pause >nul
exit