package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.House;
import bean.Position;

public class HousePriceDao extends BaseDao {

	//����ѡ��ǰ�ķ���
	public List<House> selectHouse() {

		String sql = "select * from house where id>1000 and id<1100";
		List<House> result = new ArrayList<House>();
		ResultSet rs = this.executeQuery(sql, null);
		try {
			while (rs.next()) {
				House house = new House();
				house.setId(rs.getInt("id"));
				house.setAddr(rs.getString("addr"));
				house.setPrice(rs.getLong("aver"));
				result.add(house);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.close();
		}
		return result;
	}

	
	//���ڵõ����еľ�γ����Ϣ
	public List<Position> selectUsableHouse() {
		String sql="SELECT DISTINCT house.lng, house.lat,house.aver FROM myscheme.house WHERE house.lng > 0;";
		List<Position> result = new ArrayList<Position>();
		ResultSet rs = this.executeQuery(sql, null);
		try {
			while (rs.next()) {
				Position po=new Position();
				po.setLng(rs.getString("lng"));
				po.setLat(rs.getString("lat"));
				po.setCount(rs.getString("aver"));
				result.add(po);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			this.close();
		}
		return result;
	}
	
	//���ڵõ���ѡ�ĵľ�γ����Ϣ
		public List<Position> selectSuitableHouse(int minPrice,int maxPrice) {
			String sql="SELECT DISTINCT house.lng, house.lat,house.aver FROM myscheme.house WHERE house.lng > 0 and house.aver>="+
		               String.valueOf(minPrice)+" and house.aver<="+ String.valueOf(maxPrice)+";";
			System.out.println(sql);
			List<Position> result = new ArrayList<Position>();
			ResultSet rs = this.executeQuery(sql, null);
			try {
				while (rs.next()) {
					Position po=new Position();
					po.setLng(rs.getString("lng"));
					po.setLat(rs.getString("lat"));
					po.setCount(rs.getString("aver"));
					result.add(po);
				}

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				this.close();
			}
			return result;
		}
	
	//���ڸ��·��ӵľ�γ��
	public Integer updateHouses(List<House> houses) {
		String sql = "";
		List<String> params = new ArrayList<String>();
		for (House house : houses) {
			sql += " update house set lng=? , lat=? where id=? ; ";	
			params.add(house.getLng().toString());
		//	System.out.println(house.getLng().toString());
		//	System.out.println(house.getLat().toString());
			params.add(house.getLat().toString());
			params.add(house.getId().toString());
		}
		Integer result = this.executeUpdate(sql, params);
		return result;
	}
}