Ext.define
	(
	'H.controller.Users',
		{
		extend: 'Ext.app.Controller',
		stores: ['H.store.Users'],
		models: ['H.model.User'],
		views: ['H.view.user.Edit', 'H.view.user.List', 'H.view.Viewport'],
		refs: 
			[
				{
				ref: 'list',
				selector: 'userlist'
				}
			],
		init: function()
			{
			this.control
				(
					{
					'viewport > userlist dataview':
						{
						itemdblclick: this.editUser
						},
					'userlist':
						{
						render: this.watchList
						},
					'useredit button[action=save]':
						{
						click: this.updateUser
						},
					'useredit button[action=createUser]':
						{
						click: this.createUser
						},
					'userlist button[action=addUser]':
						{
						click: this.addUser
						},
					'userlist button[action=delUser]':
						{
						click: this.delUser
						}
					}
				);
			},
		watchList: function()
			{
			this.getList().getSelectionModel().on('selectionchange',this.onSelectChange, this.getList());
			},
		onSelectChange: function(selModel, selections)
			{
			this.down('#delUser').setDisabled(selections.length === 0);
			},
		addUser: function(button)
			{
			var edit = Ext.create('H.view.user.Edit',{butAction:'createUser'}).show();
			edit.down('form').loadRecord( new  H.model.User );
			},
		editUser: function(grid, record)
			{
			var edit = Ext.create('H.view.user.Edit').show();
			edit.down('form').loadRecord(record);
			},
		updateUser: function(button)
			{
			var win    = button.up('window'),
			form   = win.down('form'),
			record = form.getRecord(),
			values = form.getValues();
			record.set(values);
			win.close();
			this.getHStoreUsersStore().sync();
			},
		createUser: function(button)
			{
			var win    = button.up('window'),
			form   = win.down('form'),
			record = form.getRecord(),
			values = form.getValues();
			record.set(values);
			win.close();
			this.getHStoreUsersStore().add(record);
			this.getHStoreUsersStore().save();
			},
  		delUser: function(button)
			{
			this.getHStoreUsersStore().removeAt(this.getList().getSelectionModel().getSelection()[0].index);
			this.getHStoreUsersStore().save();
			}
			
		}
	);
