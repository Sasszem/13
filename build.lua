local VERBOSE = false

local function runCmd(cmd)
    return os.execute(("%s%s"):format(cmd, VERBOSE and "" or " > /dev/null"))
end


local function buildLove()
    print("\27[34mRunning packaging tool...\27[39m")
    local r = runCmd("love-release")
    if not r then
        print("\27[41mError: could not run release tool!\27[49m")
        print("\27[31m> Make sure you have love-release installed!")
        print("> install it using \27[4msudo luarocks install love-release\27[0m\27[39m")
        os.exit(-1)
    end
    print("\27[92mPackeged game!\27[39m")
end

local function buildWin()
    print("\n\27[34mBuilding for windows...\27[39m")
    local r = runCmd("love-release -W 64")
    if not r then
        print("\27[41mError: could not run release tool!\27[49m")
        print("\27[31m> Make sure you have love-release installed!")
        print("> install it using \27[4msudo luarocks install love-release\27[0m\27[39m")
        os.exit(-1)
    end
    print("\27[92mPackaged game for windows (64 bit)!\27[39m")
end

local function cleanup()
    print("\27[34mCleaning up...\27[39m")
    runCmd("rm -rf love_decoded")
    runCmd("rm -rf releases")
    print("\27[92mCleanup done!\27[39m")
end

local function downloadAPK()
    local address = "https://github.com/love2d/love/releases/download/11.3/love-11.3-android-embed.apk"
    -- test if file is already there:
    local a, b, c = io.open("love-11.3-android-embed.apk")
    if b then
        print("\27[34mLöve2D APK not found, downloading...\27[39m")
        runCmd(("wget %s"):format(address))
        print("\27[92mDownloaded Löve2D APK!")
    else 
        a:close()
    end
end

local function extractApk()
    print("\27[34mExtracting APK...\27[39m")
    local r = runCmd("apktool d -s -o love_decoded love-11.3-android-embed.apk")
    if not r then
        print("\27[41mError: could not run apktool!\27[49m")
        print("\27[31m> Make sure you have apktool installed!")
        print("> \27[4mhttps://ibotpeaches.github.io/Apktool/install/\27[0m\27[39m")
        os.exit(-1)
    end
    print("\27[92mExtracted APK!")
end

local function updateApk()
    -- copy over res
    print("\27[34mUpdating APK...\27[39m")
    runCmd("cp -r asset/apkStuff/* love_decoded/")
    runCmd("mkdir love_decoded/assets")
    runCmd("cp releases/13.love love_decoded/assets/game.love")
    print("\27[92mUpdated APK!")
end

local function packageApk()
    print("\27[34mPackagin APK...\27[39m")
    local r = runCmd("apktool b -o releases/13.apk love_decoded")
    if not r then
        print("\27[41mError: apktool returned with error!\27[49m")
        os.exit(-1)
    end
    print("\27[92mPackaged APK!")
end

local function getApkSigner()
    local address = "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.1.0/uber-apk-signer-1.1.0.jar"
    -- test if file is already there:
    local a, b, c = io.open("uber-apk-signer.jar")
    if b then
        print("\27[34muber-apk-signer not found, downloading...\27[39m")
        runCmd(("wget %s"):format(address))
        runCmd("mv uber-apk-signer-1.1.0.jar uber-apk-signer.jar")
        print("\27[92mDownloaded uber-apk-signer!")
    else 
        a:close()
    end
end

local function signApk()
    getApkSigner()
    print("\27[34mSigning APK...\27[39m")
    local r = runCmd("java -jar uber-apk-signer.jar -a releases/ --overwrite")
    if not r then
        print("\27[41mError: uber-apk-signer returned with error!\27[49m")
        os.exit(-1)
    end
    print("\27[92mSigned APK!")
end

local function buildApk()
    print("\n\27[34mBUILDING APK\27[39m")
    print()
    downloadAPK()
    extractApk()
    updateApk()
    packageApk()

    signApk()
end

local function buildAll()
    cleanup()
    buildLove()
    buildWin()
    buildApk()

    print()
    print("\27[92mBuild process compleate!")
end

buildAll()