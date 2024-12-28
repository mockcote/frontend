package com.mockcote.model;

public class Tag {
    private String name;
    private int value;

    // 기본 생성자
    public Tag() {}

    // 파라미터 생성자
    public Tag(String name, int value){
        this.name = name;
        this.value = value;
    }

    // Getters and Setters
    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    public int getValue(){
        return value;
    }

    public void setValue(int value){
        this.value = value;
    }
}
