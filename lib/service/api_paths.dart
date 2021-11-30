class ApiPaths {
  static String send = "/api/auth/send";
  static String verify = "/api/auth/verify";
  static String addUserInfo = "/api/user/addInfo";
  static String updateInfo = "/api/user/updateInfo";

  static String toggleTask = "/api/task/toggleTask";
  static String deleteTask = "/api/task/deleteTask";
  static String editTask = "/api/task/update";

  static String addPet = "/api/pet/add";
  static String getPets = "/api/pet/get";
  static String removePet = "/api/pet/remove";
  static String updatePet = "/api/pet/update";

  static String getUserInfo = "/api/user/getInfo";
  static String getPetGroup = "/api/pet/group";
  static String getNotifications = "/api/notifications/get";
  static String getNotificationsFilter = "/api/notifications/filter";
  static String updateNotifications = "/api/notifications/update";
  static String addMinor = "/api/auth/minor";

  static String addTask = "/api/task/add";
  static String createTask = "/api/task/create";
  static String getTask = "/api/task/get";
  static String getTaskByPetId = "/api/task/getTasksbyPet?pet=";

  static String addByReferalCode = "/api/pet/group/addByReferalCode";
  static String updateFcmToken = "/api/auth/user/update/fcmtoken";

  static String removeCareTaker = "/api/pet/group/remove";
  static String getAllPetTasks = "/api/task/getAllPetTasks";

  static String inviteCaretaker = "/api/pet/invite/caretaker";
  static String updatePreferences = "/api/user/updatePreferences";
  static String addNotes = "/api/pet/notes/add";

  static String getTasksbyTaskID = "/api/task/getTasksbyTaskID";
  static String sendEvents = "/sendEvents";
  static String storeUpdate = "/store/update";

  // http://mypetslife.ngrok.io/api/task/getTasksbyTaskID?task=60d221c35f3d9462246c8f44
}
