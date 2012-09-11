Ext.define
	(
	'H.store.Users',
		{
		extend: 'Ext.data.Store',
		model: 'H.model.User',
		autoLoad: true,
		proxy: 
			{
			type: 'rest',
			url: '/rest/User',
			reader: 
				{
				type: 'json',
				idProperty: 'n',
				successProperty: 'success'
				},
			writer:
				{
				type: 'json',
				idProperty: 'n'
				}
			}
		}
	);