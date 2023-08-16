const userSerializer = (user) => ({
  id: user._id,
  username: user.username,
  name: user.name,
  createdAt: user.createdAt,
});

export default userSerializer;
