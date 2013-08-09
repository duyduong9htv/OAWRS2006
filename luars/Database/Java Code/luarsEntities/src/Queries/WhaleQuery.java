/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Queries;

import java.util.*;
import luars.entity.*;
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
public class WhaleQuery {

    Session session;
    Criteria criteria;

    public WhaleQuery() {
        session = HibernateUtil.getSessionFactory().
                openSession();
        session.beginTransaction();
//        session.getTransaction();

        criteria = session.createCriteria(Whales.class).setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);

        criteria.createAlias("pings", "p");
    }

    public void byID(double whaleID) {
        this.byID(new double[]{whaleID});
    }    
    
    public void byID(double[] tempIDs) {
        System.out.println("Receive an array of length: " + tempIDs.length);
        Integer[] whaleIDs = new Integer[tempIDs.length];
        for (int ii = 0; ii < tempIDs.length ; ii++) {
            whaleIDs[ii] = new Integer((int)tempIDs[ii]);
        }        
        criteria.add(Restrictions.in("whaleId", (Integer[])whaleIDs));
    }

    public void byPing(double pingID) {
        criteria.add(Restrictions.eq("p.pingId", (int) pingID));
    }

    public void byFrequency(double freqStart, double freqStop) {
        criteria.add(Restrictions.ge("freqCenter", freqStart));
        criteria.add(Restrictions.le("freqCenter", freqStop));
    }

    public void byTrueBearing(double trueBearing) {
        criteria.add(Restrictions.eq("trueBearing", trueBearing));        
    }

    public void byTrueBearing(double trueBearingStart, double trueBearingStop) {
        criteria.add(Restrictions.between("trueBearing", trueBearingStart, trueBearingStop));        
    }
    
    public void byTrueBearing() {
        criteria.add(Restrictions.isNull("trueBearing"));        
    }

    public void byRelativeBearing(double relativeBearing) {
        criteria.add(Restrictions.eq("relativeBeamCdsb", relativeBearing));        
    }

    public void byRelativeBearing(double relativeBearingStart,
            double relativeBearingStop) {
        criteria.add(Restrictions.between("relativeBeamCdsb", relativeBearingStart, relativeBearingStop));        
    }
    
    public void byRelativeBearing() {
        criteria.add(Restrictions.isNull("relativeBeamCdsb"));        
    }

    public void byTrack(double trackID) {
        criteria.createAlias("p.tracks", "t").
                add(Restrictions.eq("trackId", trackID));        
    }

    public void byTrack(String trackName) {
        criteria.createAlias("p.tracks", "t").
                add(Restrictions.eq("t.name", trackName));        
    }   
    
    public void byTrack(String[] trackNames) {            
        criteria.createAlias("p.tracks", "t").
                add(Restrictions.in("t.name", trackNames));    
    }

    public void bySource(String sourceName) {

        if (sourceName.equalsIgnoreCase("src")) {
            criteria.createAlias("p.sources", "s").
                add(Restrictions.ne("s.waveformName", "NOSRC"));
        } else {
        criteria.createAlias("p.sources", "s").
                add(Restrictions.eq("s.waveformName", sourceName));
        }
        System.out.println("Added Track Criteria (Name)");
    }

    public void byDate(Date date) {
        criteria.add(Restrictions.eq("datetime", date));
    }

    public void byDate(Date dateStart, Date dateStop) {
        criteria.add(Restrictions.between("datetime", dateStart, dateStop));
    }

    public void byTime(String timeStart, String timeStop) {
        criteria.add(Restrictions.sqlRestriction("TIME(datetime) >= (?) AND TIME(datetime) < (?)",new String[]{timeStart, timeStop}, new Type[]{Hibernate.STRING, Hibernate.STRING}));
    }
    
    public void byGroup(double groupID) {
        criteria.createAlias("whaleGroups", "wg").add(Restrictions.eq("wg.groupId", (int)groupID));
    }

    public List getWhales() {

        List resultList = new ArrayList();
        try {
            resultList = criteria.addOrder(Order.asc("datetime")).
                    list();
        } catch (HibernateException he) {
            he.printStackTrace();
        } finally {

            
            return resultList;
            

        }
    }

    public void updateWhales(Whales thisWhale) {  
        
        System.out.println("Updating Whale");
        session.update(thisWhale);
        session.getTransaction().commit();
        session.close();
//        session.update(thisWhale);
//        session.getTransaction().commit();
    }

    public void closeSession() {   
        
//        session.getTransaction().commit();
//        session.getSessionFactory().close();
        session.close();
    }

    public static void main(String[] args) {

        try {
            Session session = HibernateUtil.getSessionFactory().
                    openSession();
            session.beginTransaction();
//            Query q = session.createQuery(hql);

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
