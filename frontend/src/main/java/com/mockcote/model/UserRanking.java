package com.mockcote.model;

public class UserRanking {
    private String handle;
    private int score;
    private int ranking;

    // Getters and Setters
    public String getHandle() {
        return handle;
    }

    public void setHandle(String handle) {
        this.handle = handle;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score){
        this.score = score;
    }

    public int getRanking(){
        return ranking;
    }

    public void setRanking(int ranking){
        this.ranking = ranking;
    }
}
