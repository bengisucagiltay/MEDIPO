package utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class FileManager {

    //TODO: USERS WEB-INF dışında olmalı, Server folderı WEB-INF içinde olmalı.
    private static String[] rootCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded\\",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded\\",
                    "apache-tomcat-9.0.5/webapps/Medipo_war/"
            };


    private static String getRootDirectoryPath() {
        for (String path : rootCandidates) {
            if (new File(path).exists()) {
                return path;
            }
        }
        return null;
    }

    public static String getResourcesDirectoryPath() {
        String path = getRootDirectoryPath() + "/resources";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getUsersDirectoryPath() {
        String path = getResourcesDirectoryPath() + "/users";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getUserDirectoryPath(String userEmail){
        String path = getUsersDirectoryPath() + "/" + userEmail.replace('@', '-');
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }


    public static String getServerDirectoryPath(){
        String path = getResourcesDirectoryPath() + "/server";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }
    public static String getUsersFilePath(){
        String path = getServerDirectoryPath() + "/users.txt";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            try {
                f.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return path;
        }
    }

    public static String getPasswordsFilePath(){
        String path = getServerDirectoryPath() + "/passwords.txt";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            try {
                f.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return path;
        }
    }

    public static String getEmailsFilePath(){
        String path = getServerDirectoryPath() + "/emails.txt";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            try {
                f.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return path;
        }
    }

    public static File zip(String directoryPath, String userEmail, String userName) {
        List<File> files = Arrays.asList(new File(directoryPath).listFiles());
        File zipfile = new File(getUserDirectoryPath(userEmail) + "/" + userName + ".zip");
        // Create a buffer for reading the files
        byte[] buf = new byte[1024];
        try {
            // create the ZIP file
            ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipfile));
            // compress the files
            for(int i=0; i<files.size(); i++) {
                FileInputStream in = new FileInputStream(files.get(i).getCanonicalPath());
                // add ZIP entry to output stream
                out.putNextEntry(new ZipEntry(files.get(i).getName()));
                // transfer bytes from the file to the ZIP file
                int len;
                while((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                // complete the entry
                out.closeEntry();
                in.close();
            }
            // complete the ZIP file
            out.close();
            return zipfile;
        } catch (IOException ex) {
            System.err.println(ex.getMessage());
        }
        return null;
    }
}
