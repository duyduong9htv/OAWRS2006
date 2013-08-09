/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Testing;

import java.util.List;
import luars.entity.Pings;
import luars.util.HibernateUtil;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;

/**
 *
 * @author dreed
 */
public class TestDatabase {
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
