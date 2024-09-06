# mx_asset_path_generator

#### 用途
- 特定資料夾下的資源路徑全都轉化為dart class, 方便快速定位資源路徑
- 目前主要用途為在flutter專案方便調用assets底下的檔案

#### 使用

#### Use as an executable
1. 添加package
   `dart pub global activate mx_asset_path_generator`

2. 使用參數
    ```shell script
    使用方法:
    -d, --directory            需要檢測並生成的資料夾結構入口
                               (defaults to "assets/")
    -o, --output               輸出的資料夾路徑, 檔案名稱將會與資料夾名稱相同, 以預設為例子則會生成r/r.dart, 此檔案交由使用者自行修改引入的instance, 所以重新生成將不會覆蓋
                               (defaults to "lib/r/")
    -p, --part                 part文件名稱, 輸出的路徑dart class將會以私有類的型態放置在這, 由output目錄中的文件進行part引入
                               (defaults to "r_part.dart")
    --package                  套件名稱, 當有值時會將路徑聲明為特定套件內的資源路徑, 例如(packages/{套件名稱}/assets/images/a.png)
    -s, --[no-]print_struct    打印全部的資料夾結構
    -h, --[no-]help            說明
	```

#### Use as a library
[參考此處](test/mx_asset_path_generator_test.dart) 