package utils;

import java.io.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class FileManager {

    //TODO: USERS WEB-INF dışında olmalı, Server folderı WEB-INF içinde olmalı.
    private static String[] rootCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded",
                    "apache-tomcat-9.0.5/webapps/Medipo_war",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded",
            };

         private static String[] webRootCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded\\WEB-INF",
                    "apache-tomcat-9.0.5/webapps/Medipo_war/WEB-INF",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded\\WEB-INF",
            };
    private static String[] resourcesCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded\\resources",
                    "apache-tomcat-9.0.5/webapps/Medipo_war/resources",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded\\resources",
            };

         private static String[] webResourcesCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded\\WEB-INF\\WebResources",
                    "apache-tomcat-9.0.5/webapps/Medipo_war/WEB-INF/WebResources",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded\\WEB-INF" +
                            "\\WebResources",
            };

    public static String getResourcesDirectory() {
        for (String path : resourcesCandidates) {
            if (new File(path).exists()) {
                return path;
            }
        }
        return createResourcesDirectory();
    }

    public static String getWebResourcesDirectory() {
        for (String path : webResourcesCandidates) {
            if (new File(path).exists()) {
                return path;
            }
        }
        return createWebResourcesDirectory();
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

    private static String createWebResourcesDirectory() {
        for (String path : webRootCandidates) {
            if (new File(path).exists()) {
                String webResourcesPath = path + "/WebResources";
                File f = new File(webResourcesPath);
                f.mkdirs();
                return webResourcesPath;
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
