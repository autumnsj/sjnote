# java 使用poi读取excel内浮动图片

**注意：仅读取到xls中的浮动图片，嵌入图片此方法读取不到**
1、引入[poi](https://so.csdn.net/so/search?q=poi&spm=1001.2101.3001.7020)依赖

```xml
<dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi</artifactId>
            <version>3.17</version>
        </dependency>
        <dependency>
            <groupId>org.apache.poi</groupId>
            <artifactId>poi-ooxml</artifactId>
            <version>3.17</version>
        </dependency>

```

2、代码测试

```java
import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.*;


import java.io.File;
import java.io.FileInputStream;
import java.util.*;

public class TestReadFile {


	public static void main(String[] args) throws Exception {
		File file = new File("D:\\upload\\file.xls");
		//File file = new File("C:\\Users\\Administrator\\Desktop\\excel\\测试.xlsx");
		readXls(file);
	}

     /**
	 * 读取xls
	 * 	@PostMapping("/test")
	     public R<String> test(@RequestParam("file") MultipartFile file) throws Exception {
		HSSFWorkbook book1 = new HSSFWorkbook(file.getInputStream());
	 */
	public static void readXls(File file) throws Exception {
		HSSFWorkbook book1 = new HSSFWorkbook(new FileInputStream(file));
		//方式2 获取sheet数量，直接遍历读取每个工作表数据
		for (Sheet sheet : book1) {
			HSSFSheet hssSheet = (HSSFSheet) sheet;
			//获取工作表中绘图包
			HSSFPatriarch drawingPatriarch = hssSheet.getDrawingPatriarch();
			if (drawingPatriarch != null) {
				//获取所有图像形状
				List<HSSFShape> shapes = drawingPatriarch.getChildren();
				if (shapes != null) {
					//遍历所有形状
					for (HSSFShape shape : shapes) {
						//获取形状在工作表中的顶点位置信息（anchor锚点）
						HSSFClientAnchor anchor = (HSSFClientAnchor) shape.getAnchor();
						if (shape instanceof HSSFPicture) {
							//形状获取对应的图片数据
							HSSFPicture pic = (HSSFPicture) shape;
							HSSFPictureData picData = pic.getPictureData();
							//图片形状在工作表中的位置, 所在行列起点和终点位置
							short c1 = anchor.getCol1();
							int r1 = anchor.getRow1();
							String key = r1 + "行," + c1 + "列";
							//TODO 此处可以将图片位置和数据存入缓存中，以便解析表格数据进行对应操作及保存
							//保存图片到本地
							byte[] data = picData.getData();
							//文件扩展名
							String suffix = picData.suggestFileExtension();
							File dir = new File("D:\\upload\\resources\\images\\");
							if (!dir.exists()) {
								dir.mkdirs();
							}
							FileUtils.writeByteArrayToFile(new File(dir.getPath() + "/" + key + UUID.randomUUID() + "." + suffix), data);
						}
					}
				}
			}
		}

	}

    /**
	 * 读取xlsx
	 */
	public static void readXlsx(File file) throws Exception {
		XSSFWorkbook book = new XSSFWorkbook(new FileInputStream(file));
		//方式2 获取sheet数量，直接遍历读取每个工作表数据
		for (Sheet sheet : book) {
			XSSFSheet xssSheet = (XSSFSheet) sheet;
			//获取工作表中绘图包
			XSSFDrawing drawing = xssSheet.getDrawingPatriarch();
			if (drawing != null) {
				//获取所有图像形状
				List<XSSFShape> shapes = drawing.getShapes();
				if (shapes != null) {
					//遍历所有形状
					for (XSSFShape shape : shapes) {
						//获取形状在工作表中的顶点位置信息（anchor锚点）
						XSSFClientAnchor anchor = (XSSFClientAnchor) shape.getAnchor();
						if (shape instanceof XSSFPicture) {
							//形状获取对应的图片数据
							XSSFPicture pic = (XSSFPicture) shape;
							XSSFPictureData picData = pic.getPictureData();
							//图片形状在工作表中的位置, 所在行列起点和终点位置
							short c1 = anchor.getCol1();
							int r1 = anchor.getRow1();
							String key = r1 + "行," + c1 + "列";
							//TODO 此处可以将图片位置和数据存入缓存中，以便解析表格数据进行对应操作及保存
							//保存图片到本地
							byte[] data = picData.getData();
							//文件扩展名
							String suffix = picData.suggestFileExtension();
							File dir = new File("D:\\upload\\resources\\images\\");
							if (!dir.exists()) {
								dir.mkdirs();
							}
							FileUtils.writeByteArrayToFile(new File(dir.getPath() + "/" + key + UUID.randomUUID() + "." + suffix), data);
						}
					}
				}
			}
		}
	}
}

```

