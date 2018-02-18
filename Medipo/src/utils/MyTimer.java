package utils;

public class MyTimer {

    private static long startTime = 0;
    private static long endTime   = 0;

    public static void start(){
        startTime = System.currentTimeMillis();
    }

    public static void end() {
        endTime   = System.currentTimeMillis();
    }

    public static long getStartTime() {
        return startTime;
    }

    public static long getEndTime() {
        return endTime;
    }

    public static long getTotalTime() {
        return endTime - startTime;
    }
}
