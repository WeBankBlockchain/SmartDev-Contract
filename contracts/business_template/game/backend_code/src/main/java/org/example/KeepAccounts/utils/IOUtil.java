package org.example.KeepAccounts.utils;

import lombok.extern.slf4j.Slf4j;

import java.io.*;

@Slf4j
public class IOUtil {
    private IOUtil(){}

    private static final int BUF_SIZE = 2048;

    public static String readAsString(File file) throws IOException {
        try(InputStream in = new FileInputStream(file)){
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            copy(in, baos);
            return new String(baos.toByteArray());
        }
    }

    public static String readResourceAsString(String resource){
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        try(InputStream in = classLoader.getResourceAsStream(resource)){
            return readAsString(in);
        }
        catch (IOException ex){
            log.error("Error reading resource",ex);
            return null;
        }
    }

    public static String readAsString(InputStream inputStream) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        copy(inputStream, baos);
        return new String(baos.toByteArray());
    }

    public static void writeString(File target, String template) throws IOException{
        ByteArrayInputStream baos = new ByteArrayInputStream(template.getBytes());
        try(FileOutputStream fos = new FileOutputStream(target, false)){
            copy(baos, fos);
        }
    }

    public static void copyFolder(File srcDir, final File destDir) throws IOException{
        for(File f: srcDir.listFiles()){
            File fileCopyTo = new File(destDir, f.getName());
            if(!f.isDirectory()){
                copyFile(f, fileCopyTo);
            }
            else{
                if(!fileCopyTo.mkdirs()){
                    throw new IOException("Dir "+fileCopyTo.getAbsolutePath() + " create failed");
                }
                copyFolder(f, fileCopyTo);
            }
        }

    }

    public static void copyFile(File src, File tgt) throws IOException{
        try(FileInputStream fis = new FileInputStream(src);
            FileOutputStream fos = new FileOutputStream(tgt, false)){
            copy(fis, fos);
        }
    }

    public static void copy(InputStream is, OutputStream os) throws IOException{
        try(BufferedInputStream bis = new BufferedInputStream(is); BufferedOutputStream bos = new BufferedOutputStream(os)){
            byte[] buf = new byte[BUF_SIZE];
            int n;
            while ((n = bis.read(buf)) != -1){
                bos.write(buf, 0, n);
            }
            bos.flush();
        }
    }

    public static void removeItem(File item) {
        if(!item.isDirectory()){
            item.delete();
            return;
        }

        for(File subItem: item.listFiles()){
            removeItem(subItem);
        }
    }
}
