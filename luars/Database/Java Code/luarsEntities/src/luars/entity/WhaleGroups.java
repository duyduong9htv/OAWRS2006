package luars.entity;
// Generated Feb 15, 2012 9:15:19 AM by Hibernate Tools 3.2.1.GA


import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * WhaleGroups generated by hbm2java
 */
public class WhaleGroups  implements java.io.Serializable {


     private Integer groupId;
     private String date;
     private Integer sector;
     private Date lastUpdated;
     private Set whaleses = new HashSet(0);

    public WhaleGroups() {
    }

	
    public WhaleGroups(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    public WhaleGroups(String date, Integer sector, Date lastUpdated, Set whaleses) {
       this.date = date;
       this.sector = sector;
       this.lastUpdated = lastUpdated;
       this.whaleses = whaleses;
    }
   
    public Integer getGroupId() {
        return this.groupId;
    }
    
    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }
    public String getDate() {
        return this.date;
    }
    
    public void setDate(String date) {
        this.date = date;
    }
    public Integer getSector() {
        return this.sector;
    }
    
    public void setSector(Integer sector) {
        this.sector = sector;
    }
    public Date getLastUpdated() {
        return this.lastUpdated;
    }
    
    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    public Set getWhaleses() {
        return this.whaleses;
    }
    
    public void setWhaleses(Set whaleses) {
        this.whaleses = whaleses;
    }




}


