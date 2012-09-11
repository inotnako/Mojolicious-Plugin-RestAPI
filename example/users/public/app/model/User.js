Ext.define
	(
	'H.model.User',
		{
		extend: 'Ext.data.Model',
		idProperty: 'n',
		fields: ['n', 'full_name', 'email']
		}
	);