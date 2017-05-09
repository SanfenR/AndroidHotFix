package com.example.fensan.classloader;

import java.net.URL;

/**
 * Created on 2017/5/9
 * Created by sanfen
 *
 * @version 1.0.0
 */

public class MyClassLoader extends ClassLoader {
    @Override
    protected Package getPackage(String name) {
        return super.getPackage(name);
    }

    @Override
    public Class<?> loadClass(String name) throws ClassNotFoundException {
        return super.loadClass(name);
    }


    @Override
    protected Class<?> findClass(String name) throws ClassNotFoundException {
        return super.findClass(name);
    }


    @Override
    protected Package definePackage(String name, String specTitle, String specVersion, String specVendor, String implTitle, String implVersion, String implVendor, URL sealBase) throws IllegalArgumentException {
        return super.definePackage(name, specTitle, specVersion, specVendor, implTitle, implVersion, implVendor, sealBase);
    }
}
