# 指定文件夹路径
$musicFolderPath = "H:\B3313 OST\mp3s"
$videosFolderPath = "H:\B3313 OST\output"
$outputListPath = "H:\B3313 OST\video_list.txt"

# 获取所有音乐文件
$musicFiles = Get-ChildItem -Path $musicFolderPath -Filter *.mp3

# 使用单一图片
$imageFile = "H:\B3313 OST\img\123.jpg" # 替换为你的图片文件路径

# 初始化视频编号
$counter = 1

# 清空或创建视频列表文件
if (Test-Path $outputListPath) {
    Clear-Content $outputListPath
} else {
    New-Item $outputListPath -ItemType File
}

foreach ($musicFile in $musicFiles) {
    $baseName = [IO.Path]::GetFileNameWithoutExtension($musicFile.Name)
    $videoFile = Join-Path $videosFolderPath "$baseName.mp4"

    # 调用FFmpeg进行视频合成
    & ffmpeg -loop 1 -framerate 2 -i $imageFile -i $musicFile.FullName `
         -vf "drawtext=text='$baseName':x=10:y=H-th-10:fontcolor=white:fontsize=24, `
              drawtext=text='$counter':x=10:y=10:fontcolor=white:fontsize=24" `
         -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p `
         -shortest $videoFile -y

    # 将视频编号和名称添加到列表文件
    "${counter}: $baseName" | Out-File -Append $outputListPath

    # 增加视频编号
    $counter++
}

# 脚本完成
Write-Host "Videos have been created and listed in $outputListPath"
