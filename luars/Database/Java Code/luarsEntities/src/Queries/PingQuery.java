/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Queries;

import java.util.*;
import luars.entity.Pings;
import luars.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.*;
import org.hibernate.criterion.*;
import org.hibernate.type.Type;

/**
 *
 * @author David Reed
 */
public class PingQuery {

    Session session;
    Criteria criteria;

    public PingQuery() {
        session = HibernateUtil.getSessionFactory().
                openSession();
        session.beginTransaction();

        criteria = session.createCriteria(Pings.class).setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);
    }
    
    public void byID(double pingID) {
        this.byID(new double[]{pingID});
    }    
    
    public void byID(double[] tempIDs) {        
        Integer[] pingIDs = new Integer[tempIDs.length];
        for (int ii = 0; ii < tempIDs.length ; ii++) {
            pingIDs[ii] = new Integer((int)tempIDs[ii]);
        }        
        criteria.add(Restrictions.in("pingId", (Integer[])pingIDs));
    }    

    public void bySource(String sourceName) {

        if (sourceName.equalsIgnoreCase("src")) {            
            criteria.createAlias("sources", "s").
                    add(Restrictions.ne("s.waveformName", "NOSRC"));
        } else {
            criteria.createAlias("sources", "s").
                    add(Restrictions.eq("s.waveformName", sourceName));
        }        
    }

    public void byHeading(double heading) {
        criteria.add(Restrictions.eq("headingAvg", heading));        
    }

    public void byHeading(double headingStart, double headingStop) {
        criteria.add(Restrictions.between("headingAvg", headingStart, headingStop));        
    }

    public void byTrack(double trackID) {
        criteria.createAlias("tracks", "t").
                add(Restrictions.eq("t.trackId", trackID));        
    }

    public void byTrack(String trackName) {
        criteria.createAlias("tracks", "t").
                add(Restrictions.eq("t.name", trackName));        
    }
    
    public void byTrack(String[] trackNames) {            
        criteria.createAlias("tracks", "t").
                add(Restrictions.in("t.name", trackNames));    
    }

    public void byDate(Date date) {
        criteria.add(Restrictions.eq("startTime", date));
    }

    public void byDate(Date dateStart, Date dateStop) {
        criteria.add(Restrictions.between("startTime", dateStart, dateStop));
    }
    
    public void byTime(String timeStart, String timeStop) {
        criteria.add(Restrictions.sqlRestriction("TIME(start_time) >= (?) AND TIME(start_time) < (?)",new String[]{timeStart, timeStop}, new Type[]{Hibernate.STRING, Hibernate.STRING}));
    }

    public List getPings() {

        List resultList = new ArrayList();
        try {
            resultList = criteria.addOrder(Order.asc("startTime")).list();

            session.getTransaction().
                    commit();
        } catch (HibernateException he) {
            he.printStackTrace();
        } finally {
            return resultList;
        }
    }
    
    public void closeSession() {  
        
        session.getSessionFactory().close();
//        session.close();
    }

    public static void main(String[] args) {

        try {
            Session session = HibernateUtil.getSessionFactory().
                    openSession();
            session.beginTransaction();

            List resultList = session.createCriteria(Pings.class).
                    add(Restrictions.eq("pingId", 5)).
                    list();

            for (Object o : resultList) {
                Pings pings = (Pings) o;

                System.out.println(pings.getPingId());

            }
            session.getTransaction().
                    commit();
        } catch (HibernateException he) {
            he.printStackTrace();
        }

    }
}
