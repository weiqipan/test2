package bean;

import java.io.Serializable;

public class Position implements Serializable {
	private String lat;// γ��
	private String lng;// ����
	 private String count;//Ȩ��
	public String getLat() {
		return lat;
	}

	public void setLat(String lat) {
		this.lat = lat;
	}

	public String getLng() {
		return lng;
	}

	public void setLng(String lng) {
		this.lng = lng;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}
}
