public class RecuperarInfoSolicitudJSON {

	public class CodesDoubt {
		public String code;
		public String description;
	}

	public Integer cardApplicationId;
	public String rewardsCardNumber;
	public String curp;
	public String name;
	public String surname;
	public String secondSurname;
	public String email;
	public String cellPhoneNumber;
	public String rfc;
	public String homoclave;
	public String street;
	public String exteriorNumber;
	public String interiorNumber;
	public String zipCode;
	public String colony;
	public String otherColony;
	public String city;
	public String ifeAddressEqualsDeclaredAddress;
	public String municipality;
	public String state;
	public String creditCard;
	public String lastFourDigits;
	public String creditAutomotriz;
	public String checkBuroAuthorization;
	public String creditMortgage;
	public String acceptTerms;
	public String privacityAdvertisement;
	public String genre;
	public String birthDate;
	public String birthFederalEntity;
	public String nationality;
	public String nationalityCountry;
	public String maritalStatus;
	public String dependents;
	public String dependentsNumber;
	public String education;
	public Integer residenceTime;
	public String residenceType;
	public String homePhoneNumber;
	public String ppob;
	public Integer jobYear;
	public Integer jobMonth;
	public String contractJobType;
	public String jobType;
	public String monthlyIncome;
	public String previousJobStartDate;
	public String previousJobEndDate;
	public String previousJobCompanyName;
	public String previousJobMonthlyIncome;
	public String occupationType;
	public String companyName;
	public String activityType;
	public String jobPhone;
	public String firstReferenceFullName;
	public String firstReferencePhoneNumber;
	public String firstReferenceRelationship;
	public String secondReferenceFullName;
	public String secondReferencePhoneNumber;
	public String secondReferenceRelationship;
	public String companyZipCode;
	public String companyStreet;
	public String companyInteriorNumber;
	public String companyExteriorNumber;
	public String companyColony;
	public String companyState;
	public String companyMunicipality;
	public String fiel;
	public String originResources;
	public String destinationResources;
	public String paymentMethod;
	public String amountDisposal;
	public String averageMonthlyProvisionsNumber;
	public String paymentDay;
	public String sendStatusAccount;
	public String codigoStatusEvaluacion;
	public String reasonRejected;
	public String reasonPending;
	public String productCode;
	public String quota;
	public String canalOrigen;
	public String currentChannel;
	public String codigoOperacion;
	public String descCodigoOperacion;
	public String callId;
	public String result;
	public String queueType;
	public String status;
	public String blackLigthValidation;
	public String ineResult;
	public String pictureCaptured;
	public String productName;
	public String modifiedDate;
	public String jobExtension;
	public String sucursal;
	public String webAgent;
	public String promotorId;
	public String referredId;
	public List<CodesDoubt> codesDoubt;

	public String noteCanal;

	
	public static RecuperarInfoSolicitudJSON parse(String json) {
		return (RecuperarInfoSolicitudJSON) System.JSON.deserialize(json, RecuperarInfoSolicitudJSON.class);
	}
}