# ָ���ļ���·��
$musicFolderPath = "H:\B3313 OST\mp3s"
$videosFolderPath = "H:\B3313 OST\output"
$outputListPath = "H:\B3313 OST\video_list.txt"

# ��ȡ���������ļ�
$musicFiles = Get-ChildItem -Path $musicFolderPath -Filter *.mp3

# ʹ�õ�һͼƬ
$imageFile = "H:\B3313 OST\img\123.jpg" # �滻Ϊ���ͼƬ�ļ�·��

# ��ʼ����Ƶ���
$counter = 1

# ��ջ򴴽���Ƶ�б��ļ�
if (Test-Path $outputListPath) {
    Clear-Content $outputListPath
} else {
    New-Item $outputListPath -ItemType File
}

foreach ($musicFile in $musicFiles) {
    $baseName = [IO.Path]::GetFileNameWithoutExtension($musicFile.Name)
    $videoFile = Join-Path $videosFolderPath "$baseName.mp4"

    # ����FFmpeg������Ƶ�ϳ�
    & ffmpeg -loop 1 -framerate 2 -i $imageFile -i $musicFile.FullName `
         -vf "drawtext=text='$baseName':x=10:y=H-th-10:fontcolor=white:fontsize=24, `
              drawtext=text='$counter':x=10:y=10:fontcolor=white:fontsize=24" `
         -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p `
         -shortest $videoFile -y

    # ����Ƶ��ź�������ӵ��б��ļ�
    "${counter}: $baseName" | Out-File -Append $outputListPath

    # ������Ƶ���
    $counter++
}

# �ű����
Write-Host "Videos have been created and listed in $outputListPath"
