@echo off
chcp 65001 >nul
echo ========================================================
echo   國小四年級自然心智筆記 ‧ GitHub 一鍵推送佈署工具
echo ========================================================
echo.

:: 1. 檢查 Git 是否安裝
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [錯誤] 系統未偵測到 Git，請先安裝 Git for Windows (https://git-scm.com/)。
    echo.
    pause
    exit /b
)

:: 2. 初始化儲存庫 (若尚未初始化)
if not exist ".git" (
    echo [1/5] 初始化 Git 本地儲存庫...
    git init
    git branch -M main
) else (
    echo [1/5] Git 本地儲存庫已就緒。
)

:: 3. 加入所有檔案
echo.
echo [2/5] 正在追蹤檔案 (已自動排除大型教材PDF與暫存檔)...
git add .

:: 4. 提交版本
echo.
echo [3/5] 正在提交版本 (commit)...
git commit -m "feat: 國小四年級自然手繪心智筆記全冊與公轉模擬器 v1.0"

:: 5. 檢查 remote
echo.
git remote get-url origin >nul 2>nul
if %errorlevel% neq 0 (
    echo [4/5] 尚未設定遠端 GitHub 儲存庫網址！
    echo 請前往 https://github.com/new 建立一個新的公開 (Public) 儲存庫。
    echo.
    set /p REPO_URL="請在此貼上您的 GitHub 儲存庫網址 (例如 https://github.com/username/repo.git): "
    if not "%REPO_URL%"=="" (
        git remote add origin %REPO_URL%
    ) else (
        echo [提示] 未輸入網址，已完成本地 commit，您可以稍後手動執行 git remote add origin ^<網址^>。
        pause
        exit /b
    )
) else (
    echo [4/5] 已偵測到遠端儲存庫。
)

:: 6. 推送至 main 分支
echo.
echo [5/5] 正在推送到 GitHub main 分支...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   🎉 推送成功！
    echo.
    echo   請前往您的 GitHub 儲存庫頁面：
    echo   1. 點擊 Settings -^> Pages
    echo   2. Branch 選擇 main，目錄選擇 /(root)
    echo   3. 點擊 Save，約 1 分鐘後即可在線上開啟您的網站！
    echo ========================================================
) else (
    echo.
    echo [提示] 推送時可能需要完成 GitHub 登入驗證。若失敗請確認權限後重試。
)

echo.
pause
