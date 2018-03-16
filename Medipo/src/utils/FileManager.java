package utils;

import java.io.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class FileManager {

    private static String[] rootCandidates = {"C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded", "apache-tomcat-9.0.5/webapps/Medipo_war"};
    private static String[] resourcesCandidates = {"C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded\\resources", "apache-tomcat-9.0.5/webapps/Medipo_war/resources"};

    public static String getResourcesDirectory() {
        for (String path : resourcesCandidates) {
            if (new File(path).exists()) {
                return path;
            }
        }
        return createResourcesDirectory();
    }

    private static String createResourcesDirectory() {
        for (String path : rootCandidates) {
            if (new File(path).exists()) {
                String resourcesPath = path + "/resources";
                File f = new File(resourcesPath);
                f.mkdirs();

                return resourcesPath;
            }
        }
        return null;
    }

    public static void zipDirectory(String userDirPath, String userName){
        String sourceFile = getResourcesDirectory() + "/users/" + userDirPath;

        try {
            FileOutputStream fos = new FileOutputStream(userName + ".zip");
            ZipOutputStream zipOut = new ZipOutputStream(fos);
            File fileToZip = new File(sourceFile);

            zipFile(fileToZip, fileToZip.getName(), zipOut);
            zipOut.close();
            fos.close();
        } catch (IOException e){
            e.printStackTrace();
        }
    }

    private static void zipFile(File fileToZip, String fileName, ZipOutputStream zipOut) {
        if (fileToZip.isHidden()) {
            return;
        }
        if (fileToZip.isDirectory()) {
            File[] children = fileToZip.listFiles();
            for (File childFile : children) {
                zipFile(childFile, fileName + "/" + childFile.getName(), zipOut);
            }
            return;
        }

        try {
            FileInputStream fis = new FileInputStream(fileToZip);
            ZipEntry zipEntry = new ZipEntry(fileName);
            zipOut.putNextEntry(zipEntry);
            byte[] bytes = new byte[1024];
            int length;
            while ((length = fis.read(bytes)) >= 0) {
                zipOut.write(bytes, 0, length);
            }
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
