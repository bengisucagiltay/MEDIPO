package utils;

import java.io.File;

public class FileManager {

    public static String[] resourcesCandidates = {"C:\\Users\\Ege\\IdeaProjects\\CS491\\Medipo\\web\\resources", "../webapps/Medipo_war/resources"};

    public static String getResourcesDicrectory(){
        for (String path: resourcesCandidates
             ) {
            if(new File(path).exists()) {
                return path;
            }
        }

        return null;
    }
}
