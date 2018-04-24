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

    private static String[] rootCandidates =
            {
                    "C:\\Users\\Ege\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded",
                    "C:\\Users\\Bengisu\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_war_exploded",
                    "C:\\Users\\imgew\\git\\CS491-Medipo\\out\\artifacts\\Medipo_war_exploded",
                    "C:\\Users\\PC\\IdeaProjects\\CS491\\out\\artifacts\\Medipo_Web_exploded",
                    "apache-tomcat-9.0.5/webapps/Medipo_war"
            };

    public static String getDirPath_UserInfo(String userEmail) {
        String path = getDirPath_User(userEmail) + "/info";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getDirPath_UserDownload(String userEmail) {
        String path = getDirPath_User(userEmail) + "/download";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getDirPath_UserUpload(String userEmail) {
        String path = getDirPath_User(userEmail) + "/upload";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getDirPath_User(String userEmail) {
        String path = getDirPath_Users() + "/" + userEmail.replace('@', '-');
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getDirPath_Users() {
        String path = getDirPath_Resources() + "/users";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getFilePath_Names() {
        String path = getDirPath_Server() + "/names.txt";
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

    public static String getFilePath_Passwords() {
        String path = getDirPath_Server() + "/passwords.txt";
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

    public static String getFilePath_Emails() {
        String path = getDirPath_Server() + "/emails.txt";
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

    public static String getDirPath_Server() {
        String path = getDirPath_Resources() + "/server";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    public static String getDirPath_Resources() {
        String path = getDirPath_Root() + "/resources";
        File f = new File(path);

        if (f.exists()) {
            return path;
        } else {
            f.mkdirs();
            return path;
        }
    }

    private static String getDirPath_Root() {
        for (String path : rootCandidates) {
            if (new File(path).exists()) {
                return path;
            }
        }
        return null;
    }

    public static String convertPathForJSP(String path) {
        return path.substring(getDirPath_Root().length());
    }

    public static File zip(String email, String firstname) {

        String directoryPath = getDirPath_User(email);
        List<File> files = Arrays.asList(new File(directoryPath).listFiles());
        File zipFile = new File(directoryPath + "/" + firstname + ".zip");

        byte[] buf = new byte[1024];
        try {
            ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFile));

            for (File file : files) {
                FileInputStream in = new FileInputStream(file.getCanonicalPath());
                out.putNextEntry(new ZipEntry(file.getName()));

                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }

                out.closeEntry();
                in.close();
            }

            out.close();
            return zipFile;

        } catch (IOException ex) {
            System.err.println(ex.getMessage());
        }
        return null;
    }
}
