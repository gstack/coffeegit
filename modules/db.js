var Sequelize = require('sequelize')
    sequelize = new Sequelize(global.cgConfig.db_str),
    md5 = require('MD5');

function checkUser(user, pass, cb)
{
  sequelize
  .query('SELECT * FROM `users` where `username` = :username AND `password` = :password', null, { raw: true }, {
    username: user,
    password: md5(pass)
  })
  .success(function(users){
    if (users.length == 1)
      cb(users[0]);
    cb(false);
  });
}

function getRepos(cb)
{
  sequelize
  .query('SELECT * FROM repos', null, { raw: true }, [])
  .success(function(projects){
    console.log(projects);
    cb(projects);
  });
}

function addRepo(entry, cb)
{
  if (!entry.email)
    entry.email = "owner@thelab.sh";

  if (!entry.url || entry.url == "")
    entry.url = entry.name;

  if (!entry.last_check)
    entry.last_check = new Date().getTime()

  if (!entry.userid)
    entry.userid = 1;

  var sql = "INSERT INTO `repos` (`id`, `repo`, `desc`, `path`, `url`, `userid`, `email`, `last_check`) VALUES (NULL, :name, :desc, :path, :url, 1, :email, :last_check);";

  sequelize.query(sql, null, {raw:true}, entry).success(cb);
}

module.exports = {
  addRepo: addRepo,
  getRepos: getRepos,
  checkUser: checkUser
};
